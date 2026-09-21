def L(c):
    r, g, b = [int(c[i:i + 2], 16) / 255 for i in (0, 2, 4)]

    def f(x):
        return x / 12.92 if x <= 0.04045 else ((x + 0.055) / 1.055) ** 2.4

    R, G, B = f(r), f(g), f(b)
    return 0.2126 * R + 0.7152 * G + 0.0722 * B


def cr(a, b):
    la, lb = L(a), L(b)
    hi, lo = max(la, lb), min(la, lb)
    return (hi + 0.05) / (lo + 0.05)


pairs = [
    ("5A6663", "FFFFFF", "muted / blanco"),
    ("C93D3D", "FFFFFF", "VENCIDO / blanco"),
    ("C93D3D", "FEF6F6", "error / fondo error"),
    ("8A4F00", "FFFFFF", "PROXIMO / blanco"),
    ("00695C", "FFFFFF", "teal / blanco"),
    ("34403D", "FFFFFF", "texto / blanco"),
    ("9EA6A4", "DAE0DE", "boton apagado"),
    ("B0B8B5", "FFFFFF", "placeholder"),
    ("4A5754", "E7ECEA", "PENDIENTE / grisCaja"),
]
for a, b, name in pairs:
    print(f"{name}: {cr(a, b):.2f}:1")
