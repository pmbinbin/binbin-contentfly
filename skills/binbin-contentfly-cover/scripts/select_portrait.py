#!/usr/bin/env python3
"""Configure and randomly select a portrait for binbin-contentfly-cover."""

from __future__ import annotations

import argparse
import json
import secrets
import sys
from pathlib import Path


SKILL_DIR = Path(__file__).resolve().parent.parent
DEFAULT_CONFIG_PATH = SKILL_DIR / "config.json"
LOCAL_CONFIG_PATH = SKILL_DIR / "config.local.json"
SUPPORTED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp", ".heic"}
EXCLUDED_DIRECTORY_MARKERS = ("暂不使用", "不要使用", "do not use", "disabled")


def read_json_config(config_path: Path) -> dict[str, str]:
    if not config_path.is_file():
        return {}
    try:
        data = json.loads(config_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise RuntimeError(f"无法读取配置文件 {config_path}: {exc}") from exc
    if not isinstance(data, dict):
        raise RuntimeError(f"配置文件必须是 JSON 对象：{config_path}")
    return data


def read_config() -> dict[str, str]:
    config = read_json_config(DEFAULT_CONFIG_PATH)
    config.update(read_json_config(LOCAL_CONFIG_PATH))
    return config


def write_config(portrait_directory: Path) -> None:
    config = read_json_config(LOCAL_CONFIG_PATH)
    config["portrait_directory"] = str(portrait_directory)
    config.setdefault("default_style", "style-2-douyin-xiaohongshu")
    LOCAL_CONFIG_PATH.write_text(
        json.dumps(config, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def validate_directory(raw_path: str) -> Path:
    portrait_dir = Path(raw_path).expanduser().resolve()
    if not portrait_dir.is_dir():
        raise RuntimeError(f"人像目录不存在或不是文件夹：{portrait_dir}")
    return portrait_dir


def list_images(portrait_dir: Path) -> list[Path]:
    return sorted(
        path.resolve()
        for path in portrait_dir.rglob("*")
        if path.is_file()
        and path.suffix.lower() in SUPPORTED_EXTENSIONS
        and not any(
            directory.startswith(".")
            or any(
                marker in directory.casefold()
                for marker in EXCLUDED_DIRECTORY_MARKERS
            )
            for directory in path.relative_to(portrait_dir).parts[:-1]
        )
    )


def main() -> int:
    parser = argparse.ArgumentParser(
        description="配置人像目录，或从已配置目录随机选择一张人物参考图。"
    )
    parser.add_argument(
        "--set-dir",
        metavar="FOLDER",
        help="验证并保存新的人像目录，然后随机选择一张图片。",
    )
    parser.add_argument(
        "--list",
        action="store_true",
        help="列出已配置目录内的全部合格图片，不进行随机选择。",
    )
    args = parser.parse_args()

    try:
        config = read_config()
        if args.set_dir:
            portrait_dir = validate_directory(args.set_dir)
            write_config(portrait_dir)
        else:
            raw_path = config.get("portrait_directory")
            if not raw_path:
                raise RuntimeError(
                    "尚未配置人像目录。请询问用户后运行："
                    "scripts/select_portrait.py --set-dir '<文件夹>'"
                )
            portrait_dir = validate_directory(raw_path)

        images = list_images(portrait_dir)
        if not images:
            raise RuntimeError(
                f"人像目录内没有支持的图片：{portrait_dir}；"
                "支持 JPG、JPEG、PNG、WEBP、HEIC。"
            )

        if args.list:
            result = {
                "status": "ok",
                "portrait_directory": str(portrait_dir),
                "count": len(images),
                "images": [str(path) for path in images],
            }
        else:
            selected = secrets.choice(images)
            result = {
                "status": "ok",
                "portrait_directory": str(portrait_dir),
                "count": len(images),
                "selected_portrait": str(selected),
            }
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 0
    except RuntimeError as exc:
        print(
            json.dumps(
                {
                    "status": "needs_configuration",
                    "message": str(exc),
                    "config_path": str(LOCAL_CONFIG_PATH),
                },
                ensure_ascii=False,
                indent=2,
            ),
            file=sys.stderr,
        )
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
