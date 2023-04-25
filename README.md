<div align="center">
  <h1>vcpkg fmt Template</h1>
</div>

<div align="center">
  <p>A sample project template that uses fmt via vcpkg featuring a fully integrated CI/CD pipeline to build, test and release the project.</p>
</div>

<div align="center">

<a href="https://github.com/paulbuechner/vcpkg-fmt-template">
<img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/paulbuechner/vcpkg-fmt-template/release.yml?style=for-the-badge">
</a>
<a href="https://github.com/paulbuechner/vcpkg-fmt-template/blob/main/LICENSE">
<img alt="Github vcpkg-fmt-template License" src="https://img.shields.io/github/license/paulbuechner/vcpkg-fmt-template?style=for-the-badge">
</a>

</div>

## Project Template Features

This project template includes the following features:

- Package Manager: Utilizes [`vcpkg`](https://github.com/microsoft/vcpkg) to
  manage dependencies.
- Multiplatform Support: Supports Windows, Linux, and macOS
  with [`CMake`](https://cmake.org/)
  using [`CMakePresets.json`](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html)
  for cross-platform build configurations.
- CI/CD Integration: Offers a fully integrated CI/CD pipeline with GitHub
  Actions, which includes:
    - [`Quality`](./.github/workflows/quality.yml) Workflow: Builds and tests
      the project on all supported platforms.
    - [`Release`](./.github/workflows/release.yml) Workflow: Handles building,
      testing, packaging, and releasing the project. Integrates
      with [`changesets`](https://github.com/changesets/changesets/tree/main)
      for versioning and changelog management. Automatically uploads packages
      for supported platforms to GitHub Releases.
    - Binary Caching: Integrates
      vcpkg's [binary caching](https://learn.microsoft.com/en-us/vcpkg/users/binarycaching)
      with the [`run-vcpkg`](https://github.com/lukka/run-vcpkg) action to speed
      up builds and reduce CI costs.

## Getting Started

To get started, simply clone this repository and run the following commands to
set up the project:

Fist make sure to download vcpkg, which is managed as a submodule in this
project:

```sh
git submodule update --init --recursive
```

Optionally, install node packages to get access to the `changeset` CLI:

```sh
npm install
```

Now you can run the following commands to configure and build the project:

```sh
# Configure the project
cmake --preset vcpkg-fmt-template-ninja-multiconfiguration-vcpkg

# Build the project
cmake --build --preset vcpkg-fmt-template-ninja-multiconfiguration-vcpkg
```
