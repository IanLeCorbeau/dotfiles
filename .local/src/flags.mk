# Build-time flags for custom-built programs

# Enable ThinLTO
CFLAGS_LTO  = -flto=thin
LDFLAGS_LTO = -flto=thin -Wl,-O2

# -D_FORTIFY_SOURCE=2 requires -O2 or higher
O_FLAG      = -O2

# CFLAGS for control flow integrity. Depends on the LTO flags.
CFLAGS_CFI  = ${CFLAGS_LTO} -fvisibility=hidden -fsanitize=cfi

# Hardening Flags
HARDENING_CPPFLAGS  = -D_FORTIFY_SOURCE=2
HARDENING_CFLAGS    = -fPIE -Wformat -Wformat-security -fstack-clash-protection \
                      -fstack-protector-strong --param=ssp-buffer-size=4 -fcf-protection
HARDENING_LDFLAGS   = -Wl,-z,relro,-z,now -Wl,-pie -Wl,-zdefs
