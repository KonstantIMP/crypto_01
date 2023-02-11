module crypto.reverse;


import std.traits : isIntegral, isSigned;
import crypto.gcd : gcdExtended;


T reverseByMod(T)(T n, T mod) if (isIntegral!T && isSigned!T) {
    auto gcdResult = gcdExtended(n, mod);
    return (gcdResult[1] % mod + mod) % mod;
}

