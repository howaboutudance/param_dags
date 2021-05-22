import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setuptools.setup(
    name="example-pkg-mpenhallegon", # Replace with your own username
    version="0.0.1",
    author="Micahel Penhallegon",
    author_email="michael.penhallegon@bms.com",
    description="A small example package",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/mpenhall-celgene/pytemplate",
    project_urls={
        "Bug Tracker": "https://github.com/mpenhall-celgene/pytemplate/issues",
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "Operating System :: OS Independent",
    ],
    packages=setuptools.find_packages(),
    python_requires='>=3.6',
)