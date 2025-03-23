def cswap(a, b, c):
    return (a, b) if c == 0 else (b, a)

def scalar_to_bits(k):
    k_bin = bin(k)[2:].zfill(255)  # Pad to 255 bits
    return [int(b) for b in k_bin]

def curve25519_montgomery_ladder(k, x_p):
    p = 2**255 - 19
    k_bits = scalar_to_bits(k)

    X1 = x_p % p
    X2, Z2 = 1, 0
    X3, Z3 = X1, 1
    
    for i in range(254, -1, -1):
        if i == 254:
            k_i_plus_1 = 0
        else:
            k_i_plus_1 = k_bits[254-(i + 1)]
        k_i = k_bits[254-i]
        c = k_i_plus_1 ^ k_i
        
        X2, X3 = cswap(X2, X3, c)
        Z2, Z3 = cswap(Z2, Z3, c)
        
        t1 = (X2 + Z2) % p
        t2 = (X2 - Z2) % p
        t3 = (X3 + Z3) % p
        t4 = (X3 - Z3) % p
        t6 = pow(t1, 2, p)
        t7 = pow(t2, 2, p)
        t5 = (t6 - t7) % p
        t8 = (t4 * t1) % p
        t9 = (t3 * t2) % p
        t10 = (t8 + t9) % p
        t11 = (t8 - t9) % p
        X3 = pow(t10, 2, p)
        t12 = pow(t11, 2, p)
        t13 = (121666 * t5) % p
        X2 = (t6 * t7) % p
        t14 = (t7 + t13) % p
        Z3 = (X1 * t12) % p
        Z2 = (t5 * t14) % p
    
    c = k_bits[254]
    X2, X3 = cswap(X2, X3, c)
    Z2, Z3 = cswap(Z2, Z3, c)

    
    Z2_inv = pow(Z2, p-2, p)  
    x_q = (X2 * Z2_inv) % p
    return x_q

x_p = 44927731495623270119727621215091840270797887326986279676957494683529379806913
k = 45965849458578823337285628114947185621072782472466027602082789798859530730302
result = curve25519_montgomery_ladder(k, x_p)

print("\n",result)