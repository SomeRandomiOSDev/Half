//
//  half.c
//  Half
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#include "half.h"
#include <math.h>

#define HALF_FROM_RAW(x) (half_t){ ._bits = (x) }
#define RAW_FROM_HALF(x) x._bits
#define HALF_FROM_FP16(x) (half_t){ ._fp = (x) }
#define FP16_FROM_HALF(x) x._fp

// On Linux platforms the casting sometimes gets wacky, so we need to first promote
// the incoming value before storing it in the __fp16 type.
#if defined(__linux__)
#   define PROMOTE_SIGNED(x)   (long long)x
#   define PROMOTE_UNSIGNED(x) (unsigned long long)x
#else
#   define PROMOTE_SIGNED(x)   x
#   define PROMOTE_UNSIGNED(x) x
#endif

HALF_FUNC half_t _half_zero(void)    { return HALF_FROM_FP16(0.0); }
HALF_FUNC half_t _half_epsilon(void) { return HALF_FROM_FP16(0x1p-10); }
HALF_FUNC half_t _half_pi(void)      { return HALF_FROM_FP16(0x1.92p1); }
HALF_FUNC half_t _half_nan(void)     { return HALF_FROM_RAW(0x7E00); }

HALF_FUNC uint16_t _half_to_raw(const half_t val)   { return RAW_FROM_HALF(val); }
HALF_FUNC half_t _half_from_raw(const uint16_t val) { return HALF_FROM_RAW(val); }

HALF_OFUNC half_t _half_from(const double val)             { const __fp16 fpval = (__fp16)val; return HALF_FROM_FP16(fpval); }
HALF_OFUNC half_t _half_from(const float val)              { const __fp16 fpval = (__fp16)val; return HALF_FROM_FP16(fpval); }
HALF_OFUNC half_t _half_from(const long long val)          { const __fp16 fpval = (__fp16)PROMOTE_SIGNED(val); return HALF_FROM_FP16(fpval); }
HALF_OFUNC half_t _half_from(const long val)               { const __fp16 fpval = (__fp16)PROMOTE_SIGNED(val); return HALF_FROM_FP16(fpval); }
HALF_OFUNC half_t _half_from(const int val)                { const __fp16 fpval = (__fp16)PROMOTE_SIGNED(val); return HALF_FROM_FP16(fpval); }
HALF_OFUNC half_t _half_from(const short val)              { const __fp16 fpval = (__fp16)PROMOTE_SIGNED(val); return HALF_FROM_FP16(fpval); }
HALF_OFUNC half_t _half_from(const char val)               { const __fp16 fpval = (__fp16)PROMOTE_SIGNED(val); return HALF_FROM_FP16(fpval); }
HALF_OFUNC half_t _half_from(const unsigned long long val) { const __fp16 fpval = (__fp16)PROMOTE_UNSIGNED(val); return HALF_FROM_FP16(fpval); }
HALF_OFUNC half_t _half_from(const unsigned long val)      { const __fp16 fpval = (__fp16)PROMOTE_UNSIGNED(val); return HALF_FROM_FP16(fpval); }
HALF_OFUNC half_t _half_from(const unsigned int val)       { const __fp16 fpval = (__fp16)PROMOTE_UNSIGNED(val); return HALF_FROM_FP16(fpval); }
HALF_OFUNC half_t _half_from(const unsigned short val)     { const __fp16 fpval = (__fp16)PROMOTE_UNSIGNED(val); return HALF_FROM_FP16(fpval); }
HALF_OFUNC half_t _half_from(const unsigned char val)      { const __fp16 fpval = (__fp16)PROMOTE_UNSIGNED(val); return HALF_FROM_FP16(fpval); }

HALF_FUNC double             _half_to_double(const half_t val)    { return (double)FP16_FROM_HALF(val); }
HALF_FUNC float              _half_to_float(const half_t val)     { return (float)FP16_FROM_HALF(val); }
HALF_FUNC long long          _half_to_longlong(const half_t val)  { return (long long)FP16_FROM_HALF(val); }
HALF_FUNC long               _half_to_long(const half_t val)      { return (long)FP16_FROM_HALF(val); }
HALF_FUNC int                _half_to_int(const half_t val)       { return (int)FP16_FROM_HALF(val); }
HALF_FUNC short              _half_to_short(const half_t val)     { return (short)FP16_FROM_HALF(val); }
HALF_FUNC char               _half_to_char(const half_t val)      { return (char)FP16_FROM_HALF(val); }
HALF_FUNC unsigned long long _half_to_ulonglong(const half_t val) { return (unsigned long long)FP16_FROM_HALF(val); }
HALF_FUNC unsigned long      _half_to_ulong(const half_t val)     { return (unsigned long)FP16_FROM_HALF(val); }
HALF_FUNC unsigned int       _half_to_uint(const half_t val)      { return (unsigned int)FP16_FROM_HALF(val); }
HALF_FUNC unsigned short     _half_to_ushort(const half_t val)    { return (unsigned short)FP16_FROM_HALF(val); }
HALF_FUNC unsigned char      _half_to_uchar(const half_t val)     { return (unsigned char)FP16_FROM_HALF(val); }

HALF_FUNC half_t _half_add(const half_t lhs, const half_t rhs) { return HALF_FROM_FP16(FP16_FROM_HALF(lhs) + FP16_FROM_HALF(rhs)); }
HALF_FUNC half_t _half_sub(const half_t lhs, const half_t rhs) { return HALF_FROM_FP16(FP16_FROM_HALF(lhs) - FP16_FROM_HALF(rhs)); }
HALF_FUNC half_t _half_mul(const half_t lhs, const half_t rhs) { return HALF_FROM_FP16(FP16_FROM_HALF(lhs) * FP16_FROM_HALF(rhs)); }
HALF_FUNC half_t _half_div(const half_t lhs, const half_t rhs) { return HALF_FROM_FP16(FP16_FROM_HALF(lhs) / FP16_FROM_HALF(rhs)); }
HALF_FUNC half_t _half_fma(const half_t val, const half_t lhs, const half_t rhs) { return HALF_FROM_FP16(FP16_FROM_HALF(val) + (FP16_FROM_HALF(lhs) * FP16_FROM_HALF(rhs))); }

HALF_FUNC half_t _half_neg(const half_t val)  { return HALF_FROM_FP16(0.0 - FP16_FROM_HALF(val)); }
HALF_FUNC half_t _half_abs(const half_t val)  { return HALF_FROM_RAW(RAW_FROM_HALF(val) & 0x7FFF); } // clear sign bit
HALF_FUNC half_t _half_sqrt(const half_t val) { return _half_from(sqrt((float)FP16_FROM_HALF(val))); }

HALF_FUNC bool _half_equal(const half_t lhs, const half_t rhs) { return FP16_FROM_HALF(lhs) == FP16_FROM_HALF(rhs); }
HALF_FUNC bool _half_lt(const half_t lhs, const half_t rhs)    { return FP16_FROM_HALF(lhs) <  FP16_FROM_HALF(rhs); }
HALF_FUNC bool _half_gt(const half_t lhs, const half_t rhs)    { return FP16_FROM_HALF(lhs) >  FP16_FROM_HALF(rhs); }
HALF_FUNC bool _half_lte(const half_t lhs, const half_t rhs)   { return FP16_FROM_HALF(lhs) <= FP16_FROM_HALF(rhs); }
HALF_FUNC bool _half_gte(const half_t lhs, const half_t rhs)   { return FP16_FROM_HALF(lhs) >= FP16_FROM_HALF(rhs); }
