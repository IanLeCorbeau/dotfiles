#!/bin/sh

# DISCLAIMER: Use at your own risks and perils. This will install LLVM/Clang
# and set as the default toolchain on Debian.
#
# Requirement: add the proper apt.llvm.org repo first:
# https://ianlecorbeau.github.io/latest-llvm-clang-debian.html

set -e

# Which version is it.
VERSION="16"

# Install the LLVM/Clang packages.
apt-get install -y libllvm"${VERSION}" llvm-"${VERSION}" llvm-"${VERSION}"-dev \
	llvm-"${VERSION}"-runtime clang-"${VERSION}" clang-tools-"${VERSION}" \
	libclang-common-"${VERSION}"-dev libclang-"${VERSION}"-dev libclang1-"${VERSION}" \
	clang-format-"${VERSION}" python3-clang-"${VERSION}" clang-tidy-"${VERSION}" \
	libclang-rt-"${VERSION}"-dev libpolly-"${VERSION}"-dev libfuzzer-"${VERSION}"-dev \
	lldb-"${VERSION}" lld-"${VERSION}" libc++-"${VERSION}"-dev libc++abi-"${VERSION}"-dev \
	libomp-"${VERSION}"-dev libunwind-"${VERSION}"-dev libmlir-"${VERSION}"-dev \
	flang-"${VERSION}"

# Use update-alternatives to set as default toolchain.
# This *has* to be done in order to ensure that it works as expected.
update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-"${VERSION}" 100 \
	--slave /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-"${VERSION}" \
	--slave /usr/bin/llvm-as llvm-as /usr/bin/llvm-as-"${VERSION}" \
	--slave /usr/bin/llvm-bcanalyzer llvm-bcanalyzer /usr/bin/llvm-bcanalyzer-"${VERSION}" \
	--slave /usr/bin/llvm-cov llvm-cov /usr/bin/llvm-cov-"${VERSION}" \
	--slave /usr/bin/llvm-diff llvm-diff /usr/bin/llvm-diff-"${VERSION}" \
	--slave /usr/bin/llvm-dis llvm-dis /usr/bin/llvm-dis-"${VERSION}" \
	--slave /usr/bin/llvm-dwarfdump llvm-dwarfdump /usr/bin/llvm-dwarfdump-"${VERSION}" \
	--slave /usr/bin/llvm-extract llvm-extract /usr/bin/llvm-extract-"${VERSION}" \
	--slave /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-"${VERSION}" \
	--slave /usr/bin/llvm-mc llvm-mc /usr/bin/llvm-mc-"${VERSION}" \
	--slave /usr/bin/llvm-nm llvm-nm /usr/bin/llvm-nm-"${VERSION}" \
	--slave /usr/bin/llvm-objdump llvm-objdump /usr/bin/llvm-objdump-"${VERSION}" \
	--slave /usr/bin/llvm-ranlib llvm-ranlib /usr/bin/llvm-ranlib-"${VERSION}" \
	--slave /usr/bin/llvm-readobj llvm-readobj /usr/bin/llvm-readobj-"${VERSION}" \
	--slave /usr/bin/llvm-rtdyld llvm-rtdyld /usr/bin/llvm-rtdyld-"${VERSION}" \
	--slave /usr/bin/llvm-size llvm-size /usr/bin/llvm-size-"${VERSION}" \
	--slave /usr/bin/llvm-stress llvm-stress /usr/bin/llvm-stress-"${VERSION}" \
	--slave /usr/bin/llvm-symbolizer llvm-symbolizer /usr/bin/llvm-symbolizer-"${VERSION}" \
	--slave /usr/bin/llvm-tblgen llvm-tblgen /usr/bin/llvm-tblgen-"${VERSION}" \
	--slave /usr/bin/llvm-objcopy llvm-objcopy /usr/bin/llvm-objcopy-"${VERSION}" \
	--slave /usr/bin/llvm-strip llvm-strip /usr/bin/llvm-strip-"${VERSION}"

update-alternatives --install /usr/bin/clang clang /usr/bin/clang-"${VERSION}" 100 \
	--slave /usr/bin/clang++ clang++ /usr/bin/clang++-"${VERSION}" \
	--slave /usr/bin/asan_symbolize asan_symbolize /usr/bin/asan_symbolize-"${VERSION}" \
	--slave /usr/bin/clang-cpp clang-cpp /usr/bin/clang-cpp-"${VERSION}" \
	--slave /usr/bin/clang-cl clang-cl /usr/bin/clang-cl-"${VERSION}" \
	--slave /usr/bin/ld.lld ld.lld /usr/bin/ld.lld-"${VERSION}" \
	--slave /usr/bin/lld lld /usr/bin/lld-"${VERSION}" \
	--slave /usr/bin/lld-link lld-link /usr/bin/lld-link-"${VERSION}" \
	--slave /usr/bin/clang-format clang-format /usr/bin/clang-format-"${VERSION}" \
	--slave /usr/bin/clang-format-diff clang-format-diff /usr/bin/clang-format-diff-"${VERSION}" \
	--slave /usr/bin/clang-include-fixer clang-include-fixer /usr/bin/clang-include-fixer-"${VERSION}" \
	--slave /usr/bin/clang-offload-bundler clang-offload-bundler /usr/bin/clang-offload-bundler-"${VERSION}" \
        --slave /usr/bin/clang-query clang-query /usr/bin/clang-query-"${VERSION}" \
        --slave /usr/bin/clang-rename clang-rename /usr/bin/clang-rename-"${VERSION}" \
        --slave /usr/bin/clang-reorder-fields clang-reorder-fields /usr/bin/clang-reorder-fields-"${VERSION}" \
        --slave /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-"${VERSION}" \
        --slave /usr/bin/lldb lldb /usr/bin/lldb-"${VERSION}" \
        --slave /usr/bin/lldb-server lldb-server /usr/bin/lldb-server-"${VERSION}"

# Icing on the cake
update-alternatives --install /usr/bin/cc cc /usr/bin/clang-"${VERSION}" 100
update-alternatives --install /usr/bin/ld ld /usr/bin/ld.lld-"${VERSION}" 100
update-alternatives --install /usr/bin/ar ar /usr/bin/llvm-ar-"${VERSION}" 100
update-alternatives --install /usr/bin/ranlib ranlib /usr/bin/llvm-ranlib-"${VERSION}" 100
update-alternatives --install /usr/bin/objcopy objcopy /usr/bin/llvm-objcopy-"${VERSION}" 100
update-alternatives --install /usr/bin/strip strip /usr/bin/llvm-strip-"${VERSION}" 100
