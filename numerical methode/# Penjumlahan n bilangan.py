# Penjumlahan n bilangan
n = int(input("Masukkan jumlah bilangan: "))

total = 0
for i in range(1, n+1):
    x = int(input(f"Masukkan bilangan ke-{i}: "))
    total += x

print("Hasil penjumlahan =", total)
