# ask for the number of dvds
dvds = int(input("enter dvds purchased: "))

# Determine points earned
if dvds == 0:
    points = 0
elif dvds == 1:
    points = 2
elif dvds == 2:
    points = 5
elif dvds == 3:
    points = 10
else:
    points = 25

# show points
print("points earned:", points)
