module crypto.reverse;


import std.traits : isIntegral;
import crypto.gcd : gcdExtended;


T reverseByMod(T)(T n, T mod) if (isIntegral!T) {
    auto gcdResult = gcdExtended(n, mod);
    return (gcdResult[1] % mod + mod) % mod;
}

