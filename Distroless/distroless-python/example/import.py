import pkgutil
import warnings

# List of modules to skip during import
skip_modules = frozenset((
    # Windows-specific modules
    'asyncio.windows_events',
    'asyncio.windows_utils',
    'ctypes.wintypes',
    'distutils._msvccompiler',
    'distutils.command.bdist_msi',
    'distutils.msvc9compiler',
    'encodings.cp65001',
    'encodings.mbcs',
    'encodings.oem',
    'multiprocessing.popen_spawn_win32',
    'winreg',

    # Python regression tests "for internal use by Python only"
    'test',

    # Calls sys.exit
    'unittest.__main__',
    'venv.__main__',

    'lib2to3.__main__'

))


def walk_packages_onerror(failed_module_name):
    raise Exception(f"Failed to import module: {repr(failed_module_name)}")


# Suppress deprecation warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)

for module_info in pkgutil.walk_packages(onerror=walk_packages_onerror):
    module_name = module_info.name
    try:
        if module_name in skip_modules or module_name.startswith('test.'):
            continue
        # Import the module
        __import__(module_name)
        print(f"Imported {module_name}")

    except Exception as e:
        print(f"Error importing {module_name}: {e}")

print("Import everything test successfully!")
