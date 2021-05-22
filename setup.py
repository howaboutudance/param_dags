import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setuptools.setup(
    name="param-dags", # Replace with your own username
    version="0.0.1",
    author="Micahel Penhallegon",
    author_email="michael.penhallegon@bms.com",
    description="paramatized dag expirements",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/mpenhall-celgene/param_dags",
    project_urls={
        "Bug Tracker": "https://github.com/mpenhall-celgene/param_dags/issues",
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "Operating System :: OS Independent",
    ],
    packages=setuptools.find_packages(),
    python_requires='>=3.6',
)