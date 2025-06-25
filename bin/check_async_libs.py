#!/usr/bin/env python3
"""
Async Python Libraries Checker

This script checks installed Python packages for async capabilities and provides
helpful information about their documentation and common use cases.

Usage:
    python check_async_libs.py [--install]

Options:
    --install       Attempt to install recommended async libraries
"""

import asyncio
import importlib.util
import json
import sys
from typing import Dict, Set, Tuple

# Define color codes for terminal output
COLORS = {
    "HEADER": "\033[95m",
    "BLUE": "\033[94m",
    "GREEN": "\033[92m",
    "YELLOW": "\033[93m",
    "RED": "\033[91m",
    "ENDC": "\033[0m",
    "BOLD": "\033[1m",
    "UNDERLINE": "\033[4m",
}


# List of common async libraries with their documentation URLs and descriptions
ASYNC_LIBRARIES = {
    "aiohttp": {
        "description": "Asynchronous HTTP client/server framework",
        "docs": "https://docs.aiohttp.org/",
        "common_use": "Web scraping, API clients, web servers",
    },
    "asyncio": {
        "description": "Python's built-in asynchronous I/O framework",
        "docs": "https://docs.python.org/3/library/asyncio.html",
        "common_use": "Coroutines, tasks, event loops",
    },
    "httpx": {
        "description": "A next-generation HTTP client with both sync and async APIs",
        "docs": "https://www.python-httpx.org/",
        "common_use": "Modern alternative to requests with async support",
    },
    "fastapi": {
        "description": "Modern, fast web framework for building APIs with Python",
        "docs": "https://fastapi.tiangolo.com/",
        "common_use": "Building high-performance APIs with automatic docs",
    },
    "asyncpg": {
        "description": "High performance PostgreSQL client library",
        "docs": "https://magicstack.github.io/asyncpg/current/",
        "common_use": "Async database operations with PostgreSQL",
    },
    "motor": {
        "description": "Async MongoDB driver",
        "docs": "https://motor.readthedocs.io/",
        "common_use": "Async database operations with MongoDB",
    },
    "aioredis": {
        "description": "Async Redis client",
        "docs": "https://aioredis.readthedocs.io/",
        "common_use": "Async operations with Redis",
    },
    "aiokafka": {
        "description": "Async Kafka client",
        "docs": "https://aiokafka.readthedocs.io/",
        "common_use": "Async Kafka producers and consumers",
    },
    "trio": {
        "description": "Alternative async concurrency library",
        "docs": "https://trio.readthedocs.io/",
        "common_use": "Structured concurrency with emphasis on safety",
    },
    "anyio": {
        "description": "Compatibility layer for multiple async frameworks",
        "docs": "https://anyio.readthedocs.io/",
        "common_use": "Write code that works with asyncio, trio, and others",
    },
    "uvicorn": {
        "description": "ASGI server implementation",
        "docs": "https://www.uvicorn.org/",
        "common_use": "Run ASGI applications (FastAPI, Starlette, etc.)",
    },
    "starlette": {
        "description": "Lightweight ASGI framework",
        "docs": "https://www.starlette.io/",
        "common_use": "Basis for FastAPI, middleware, routing, etc.",
    },
    "asgiref": {
        "description": "ASGI specification and utilities",
        "docs": "https://asgi.readthedocs.io/",
        "common_use": "ASGI reference implementation and utilities",
    },
    "aiofiles": {
        "description": "File operations for asyncio",
        "docs": "https://github.com/Tinche/aiofiles",
        "common_use": "Async file I/O operations",
    },
    "websockets": {
        "description": "WebSocket implementation for Python",
        "docs": "https://websockets.readthedocs.io/",
        "common_use": "WebSocket clients and servers",
    },
}


async def check_package(package_name: str) -> bool:
    """
    Check if a Python package is installed.

    Args:
        package_name: Name of the package to check

    Returns:
        bool: True if the package is installed, False otherwise
    """
    try:
        spec = importlib.util.find_spec(package_name)
        return spec is not None
    except (ImportError, AttributeError):
        return False


async def get_installed_packages() -> Set[str]:
    """
    Get a set of all installed Python packages.

    Returns:
        Set[str]: Set of installed package names
    """
    try:
        # Use pip to list installed packages in JSON format
        process = await asyncio.create_subprocess_exec(
            sys.executable,
            "-m",
            "pip",
            "list",
            "--format=json",
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )
        stdout, _ = await process.communicate()

        packages_json = json.loads(stdout)
        return {package["name"].lower() for package in packages_json}
    except Exception as e:
        print(f"{COLORS['RED']}Error getting installed packages: {e}{COLORS['ENDC']}")
        return set()


async def check_async_libraries() -> Tuple[Dict[str, bool], Set[str]]:
    """
    Check which async libraries are installed.

    Returns:
        Tuple containing a dictionary of library status and a set of installed libraries
    """
    installed_packages = await get_installed_packages()
    results = {}

    # Check for each async library
    for lib in ASYNC_LIBRARIES:
        is_installed = await check_package(lib)
        results[lib] = is_installed

    return results, installed_packages


async def install_package(package_name: str) -> bool:
    """
    Install a Python package using pip.

    Args:
        package_name: Name of the package to install

    Returns:
        bool: True if installation was successful, False otherwise
    """
    try:
        process = await asyncio.create_subprocess_exec(
            sys.executable,
            "-m",
            "pip",
            "install",
            package_name,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )
        stdout, stderr = await process.communicate()

        if process.returncode != 0:
            print(f"{COLORS['RED']}Failed to install {package_name}:{COLORS['ENDC']}")
            print(stderr.decode())
            return False

        print(f"{COLORS['GREEN']}Successfully installed {package_name}{COLORS['ENDC']}")
        return True
    except Exception as e:
        print(f"{COLORS['RED']}Error installing {package_name}: {e}{COLORS['ENDC']}")
        return False


async def main():
    """Main function to check async libraries and optionally install them."""
    print(
        f"{COLORS['HEADER']}{COLORS['BOLD']}Async Python Libraries Checker{COLORS['ENDC']}"
    )
    print(
        f"{COLORS['BLUE']}Checking for async libraries in your Python environment...{COLORS['ENDC']}"
    )

    # Check which async libraries are installed
    results, installed_packages = await check_async_libraries()

    # Display results
    print(f"\n{COLORS['BOLD']}Installed Async Libraries:{COLORS['ENDC']}")
    installed_count = 0

    for lib, installed in results.items():
        status = (
            f"{COLORS['GREEN']}Installed{COLORS['ENDC']}"
            if installed
            else f"{COLORS['RED']}Not Installed{COLORS['ENDC']}"
        )
        print(f"{COLORS['BOLD']}{lib}{COLORS['ENDC']}: {status}")
        if installed:
            installed_count += 1

    print(
        f"\n{COLORS['BLUE']}Summary: {installed_count}/{len(ASYNC_LIBRARIES)} async libraries installed.{COLORS['ENDC']}"
    )

    # Show information about installed libraries
    if installed_count > 0:
        print(f"\n{COLORS['BOLD']}Details for Installed Libraries:{COLORS['ENDC']}")
        for lib, installed in results.items():
            if installed:
                lib_info = ASYNC_LIBRARIES[lib]
                print(f"\n{COLORS['BOLD']}{COLORS['BLUE']}{lib}{COLORS['ENDC']}")
                print(f"  Description: {lib_info['description']}")
                print(f"  Common Uses: {lib_info['common_use']}")
                print(
                    f"  Documentation: {COLORS['UNDERLINE']}{lib_info['docs']}{COLORS['ENDC']}"
                )

    # Recommend installing useful libraries
    recommended = {
        "aiohttp": "Popular HTTP client/server library",
        "fastapi": "Modern, fast web framework",
        "httpx": "Modern HTTP client with async support",
        "asyncpg": "High-performance PostgreSQL client",
    }

    not_installed = [lib for lib in recommended if not results.get(lib, False)]

    if not_installed and "--install" in sys.argv:
        print(
            f"\n{COLORS['YELLOW']}Installing recommended libraries...{COLORS['ENDC']}"
        )
        for lib in not_installed:
            await install_package(lib)
    elif not_installed:
        print(f"\n{COLORS['YELLOW']}Recommended libraries to install:{COLORS['ENDC']}")
        for lib in not_installed:
            print(f"  {COLORS['BOLD']}{lib}{COLORS['ENDC']}: {recommended[lib]}")
        print(
            f"\nTo install these libraries, run: {COLORS['BOLD']}python {sys.argv[0]} --install{COLORS['ENDC']}"
        )


if __name__ == "__main__":
    asyncio.run(main())
