class PersonalInfo:
    def __init__(self, name, address, age, phone_number):
        self.name = name
        self.address = address
        self.age = age
        self.phone_number = phone_number

    # get method (getters)
    def get_name(self):
        return self.name

    def get_address(self):
        return self.address

    def get_age(self):
        return self.age

    def get_phone_number(self):
        return self.phone_number

    # Mutator method (setters)
    def set_name(self, name):
        self.name = name

    def set_address(self, address):
        self.address = address

    def set_age(self, age):
        self.age = age

    def set_phone_number(self, phone_number):
        self.phone_number = phone_number

# Creating instances
person1 = PersonalInfo("Omar", "street 123", 25, "123-456-7890")
person2 = PersonalInfo("Omran", "street 1234", 30, "987-654-3210")
person3 = PersonalInfo("Maryam", "street 12345", 28, "555-666-7777")

# print the information
print("Person 1:", person1.get_name(), person1.get_address(), person1.get_age(), person1.get_phone_number())
print("Person 2:", person2.get_name(), person2.get_address(), person2.get_age(), person2.get_phone_number())
print("Person 3:", person3.get_name(), person3.get_address(), person3.get_age(), person3.get_phone_number())
