class Pet:
    def __init__(self, name, animal_type, age):
        self.name = name
        self.animal_type = animal_type
        self.age = age

    # getter
    def get_name(self):
        return self.name

    def get_animal_type(self):
        return self.animal_type

    def get_age(self):
        return self.age

# list pets
pets_list = []

# ask user how many pets
num_pets = int(input("How many pets do you want to enter? "))

# gather pet information
for i in range(num_pets):
    name = input(f"Enter the name of pet {i+1}: ")
    animal_type = input(f"Enter the type of pet {i+1} (e.g., Dog, Cat, Bird): ")
    age = int(input(f"Enter the age of pet {i+1}: "))
    
    pet = Pet(name, animal_type, age)  # Create pet object
    pets_list.append(pet)  # Store in the list

# ask the user how they want to display pets
option = input("Do you want to list (A) all pets or (B) a specific type of pet? (A/B): ").upper()

if option == "A":
    print("\nAll Pets:")
    for pet in pets_list:
        print(f"{pet.get_name()} - {pet.get_animal_type()} - {pet.get_age()} years old")
elif option == "B":
    chosen_type = input("Enter the type of pet you want to see (e.g., Dog, Cat, Bird): ")
    print(f"\nPets of type '{chosen_type}':")
    for pet in pets_list:
        if pet.get_animal_type().lower() == chosen_type.lower():
            print(f"{pet.get_name()} - {pet.get_age()} years old")
