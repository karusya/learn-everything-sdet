# Java OOP Concepts: Complete Guide for SDET

## Introduction to OOP

Object Oriented Programming (OOPs) concept is based on the concept of **objects**, which contain **data (fields/attributes)** and **behavior (methods/functions)**.

## Core OOP Concepts

### Class
- **Definition**: Defines the structure, attributes, and behaviors. It is like a blueprint.
- **Syntax**:
```java
class ClassName {
    // variables
    // methods
}
```

### Object
- **Definition**: A real instance of the class, holding actual data. It is a physical entity.
- **Syntax**:
```java
ClassName objectName = new ClassName();
```

### Example: Car Class
```java
// Defining the class (Blueprint)
public class Car {
    // Fields (attributes)
    String make;
    char model;
    int year;

    // Method to display car details
    void displayDetails() {
        System.out.println("Car Make: " + make);
        System.out.println("Car Model: " + model);
        System.out.println("Car Year: " + year);
        // OR
        System.out.println(make + " " + model + " " + year);
    }
}

// Main class to create an object
public class Main {
    public static void main(String[] args) {
        // Creating an object of the Car class
        Car myCar = new Car();

        // Assigning data using object reference
        myCar.make = "Toyota";
        myCar.model = 'C';
        myCar.year = 2020;

        // Calling the method of the object
        myCar.displayDetails();
    }
}
```

**Output:**
```
Car Make: Toyota
Car Model: C
Car Year: 2020
```

## Data Assignment Methods

### 3 Ways to Store Data into Variables

#### 1. By using object reference variable
```java
myCar.make = "Toyota";
myCar.model = 'C';
myCar.year = 2020;
```

#### 2. By using method
```java
// User defined method (to directly assign data in main class)
void setCarData(String cMake, char cModel, int cYear) {
    make = cMake;
    model = cModel;
    year = cYear;
}

// Assigning data using user defined method
myCar.setCarData("Toyota", 'C', 2020);
myCar.displayDetails();
```

#### 3. By using constructor
```java
// Constructor to initialize the object (this)
Car(String make, char model, int year) {
    this.make = make;
    this.model = model;
    this.year = year;
}

// Creating object & Assigning data using constructor
Car myCar = new Car("Toyota", 'C', 2020);
```

## Methods

Block or group of statements which will perform certain task. We must call the method through object.

### Method Types

#### 1. No parameters → No return value
```java
void m1() {
    System.out.println("Hello..");
}
```

#### 2. No parameters → Returns value
```java
String m2() {
    return("Hello how are you?");
}
```

#### 3. Takes parameters → No return value
```java
void m3(String name) {
    System.out.println("Hello " + name);
}
```

#### 4. Takes parameters → Returns value
```java
String m4(String name) {
    return("Hello " + name);
}
```

## Constructor

A constructor in Java is a special type of method used to initialize objects. Constructors are automatically called when an object is created using the `new` keyword.

### Types of Constructors

#### Default Constructor
```java
public class ConstructorDemo {
    int x, y;

    ConstructorDemo() {
        x = 10;
        y = 20;
    }

    void sum() {
        System.out.println(x + y);
    }

    public static void main(String[] args) {
        ConstructorDemo cd = new ConstructorDemo();
        cd.sum(); // 30
    }
}
```

#### Parameterized Constructor
```java
public class ConstructorDemo {
    int x, y;

    ConstructorDemo(int a, int b) {
        x = a;
        y = b;
    }

    void sum() {
        System.out.println(x + y);
    }

    public static void main(String[] args) {
        ConstructorDemo cd = new ConstructorDemo(100, 200);
        cd.sum(); // 300
    }
}
```

### Method vs Constructor
| Feature | Method | Constructor |
|---------|--------|-------------|
| Name | Can be anything | Must be same as class name |
| Return value | May or may not return | Never returns a value |
| Access modifier | Can have any | No access modifier needed |
| Purpose | Specify logic | Initialize values |

## Four Pillars of OOP

### 1. Encapsulation
- **Definition**: Hiding implementation details and exposing only necessary features.
- **Purpose**: Provide security to class variables

#### Implementation Rules:
- All variables should be **private**
- For every variable there should be **2 methods** (getter & setter)
- Variables can be operated only through methods

```java
public class Account {
    private int accno;
    private String name;
    private double amount;

    public int getAccno() {
        return accno;
    }

    public void setAccno(int accno) {
        this.accno = accno;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }
}

public class AccountMain {
    public static void main(String[] args) {
        Account acc = new Account();
        acc.setAccno(10101);
        acc.setName("John");
        acc.setAmount(12552.535);

        System.out.println(acc.getAccno());
        System.out.println(acc.getName());
        System.out.println(acc.getAmount());
    }
}
```

### 2. Inheritance
- **Definition**: Acquiring all the properties (Variables) & behaviors (methods) from one class to another class.
- **Purpose**: Code reuse and avoid duplication

#### Types:
- **Single Inheritance**: One parent, one child
- **Multilevel Inheritance**: Parent → Child → Grandchild
- **Hierarchical Inheritance**: One parent, multiple children

```java
class Parent {
    void display(int a) {
        System.out.println(a);
    }
}

class Child1 extends Parent {
    void show(int b) {
        System.out.println(b);
    }
}

class Child2 extends Parent {
    void print(int c) {
        System.out.println(c);
    }
}

public class HierarchyInheritance {
    public static void main(String[] args) {
        Child1 c1 = new Child1();
        c1.display(100);
        c1.show(200);

        Child2 c2 = new Child2();
        c2.display(10);
        c2.print(20);
    }
}
```

### 3. Polymorphism
- **Definition**: One thing can have many forms (One method can have many forms i.e. different parameters)

#### Types:

##### Method Overloading (Compile-time Polymorphism)
```java
class Calculator {
    // Overloaded method with void return type
    void add() {
        int a = 10; // Instance variable
        int b = 20; // Instance variable
        int sum = a + b;
        System.out.println("Sum of " + a + " and " + b + ": " + sum);
    }

    // Overloaded method to add three integers
    int add(int a, int b, int c) {
        return a + b + c;
    }

    // Overloaded method to add two double values
    double add(double a, double b) {
        return a + b;
    }
}

public class Main {
    public static void main(String[] args) {
        Calculator calc = new Calculator();

        // Calls the method that prints the result directly
        calc.add(); // Sum of 10 and 20: 30

        System.out.println(calc.add(2, 3, 4)); // 9
        System.out.println(calc.add(2.5, 3.5)); // 6.0
    }
}
```

##### Method Overriding (Runtime Polymorphism)
```java
class Bank {
    double roi() {
        return 0;
    }
}

class ICICI extends Bank {
    double roi() {
        return 10.5;
    }
}

class SBI extends Bank {
    double roi() {
        return 11.5;
    }
}

public class OverridingDemo {
    public static void main(String[] args) {
        ICICI ic = new ICICI();
        System.out.println(ic.roi()); // 10.5

        SBI sb = new SBI();
        System.out.println(sb.roi()); // 11.5
    }
}
```

### 4. Abstraction
- **Definition**: Hiding implementation details using abstract classes or interfaces.

## Call by Value vs Call by Reference

### Call by Value
When you pass a primitive type to a method, a copy of the value is passed. Changes inside method don't affect original variable.

```java
public class Test {
    void m1(int number) {
        number = number + 10;
        System.out.println("Value in the method: " + number);
    }
}

public class CallByValue {
    public static void main(String[] args) {
        Test test = new Test();
        int number = 100;
        System.out.println("Before method: " + number); // 100
        test.m1(number); // 110
        System.out.println("After method: " + number); // 100 (unchanged)
    }
}
```

### Call by Reference
Instead of value, passing the object reference.

```java
public class Test {
    int number;

    void m2(Test t) {
        t.number = t.number + 10;
        System.out.println("Value in the method: " + t.number);
    }
}

public class CallByReference {
    public static void main(String[] args) {
        Test test = new Test();
        test.number = 100;

        System.out.println("Value before method: " + test.number); // 100
        test.m2(test); // 110
        System.out.println("Value after method: " + test.number); // 110 (changed)
    }
}
```

## this Keyword

Used when constructor/method parameter has same name as instance variable.

```java
public class ThisKeyword {
    int x, y; // class variables

    // Example for method
    void setData(int x, int y) {
        this.x = x;
        this.y = y;
    }

    // Example for constructor
    ThisKeyword(int x, int y) {
        this.x = x;
        this.y = y;
    }

    void display() {
        System.out.println(x + " " + y);
    }

    public static void main(String[] args) {
        ThisKeyword th = new ThisKeyword(10, 20);
        th.display();
    }
}
```

## super Keyword

Used to invoke immediate parent class variable, method, or constructor.

```java
class Animal {
    String color = "white";

    Animal() {
        System.out.println("This is Animal..");
    }

    void eat() {
        System.out.println("eating....");
    }
}

class Dog extends Animal {
    String color = "black";

    void displayColor() {
        System.out.println(super.color); // white
    }

    void eat() {
        super.eat(); // calling parent class method
    }

    Dog() {
        super(); // invoke parent class constructor
        System.out.println("This is Dog..");
    }
}
```

## static Keyword

Make variable static only if common data across multiple objects. Saves memory and updating is easy.

```java
public class StaticDemo {
    static int a = 10; // static variable
    int b = 20; // non-static variable

    static void m1() { // static method
        System.out.println("this is m1 static method...");
    }

    void m2() { // non-static
        System.out.println("this is m2 non-static method...");
    }

    public static void main(String[] args) {
        System.out.println(a);
        m1();

        StaticDemo sd = new StaticDemo();
        System.out.println(sd.b);
        sd.m2();
    }
}
```

## final Keyword

Applied to variables (constants), methods (cannot override), or classes (cannot extend).

```java
final class Test {
    final int x = 100;

    final void m1() {
        System.out.println("m1 from Test1");
    }
}

class Test2 extends Test { // Cannot extend final class
    void m1() { // Cannot override final method
        System.out.println("m1 from Test2");
    }
}
```

## Interface

Blueprint of class containing final & static variables and abstract methods.

```java
interface Shape {
    int length = 10; // final and static
    int width = 20; // final and static

    void circle(); // abstract method

    default void square() {
        System.out.println("this is square - default method....");
    }

    static void rectangle() {
        System.out.println("this is rectangle - static method...");
    }
}

public class InterfaceDemo implements Shape {
    public void circle() {
        System.out.println("this is circle – abstract method...");
    }

    public static void main(String[] args) {
        InterfaceDemo idobj = new InterfaceDemo();
        idobj.circle();
        idobj.square();
        Shape.rectangle();

        System.out.println(Shape.length + Shape.width); // 30
    }
}
```

## Multiple Inheritance using Interface

```java
interface I1 {
    int x = 100;
    void m1();
}

interface I2 {
    int y = 200;
    void m2();
}

public class MultipleInheritance implements I1, I2 {
    public void m1() {
        System.out.println("this is m1...");
    }

    public void m2() {
        System.out.println("this is m2...");
    }

    public static void main(String[] args) {
        MultipleInheritance mi = new MultipleInheritance();
        mi.m1();
        mi.m2();
        System.out.println(mi.x);
        System.out.println(mi.y);
    }
}
```

## Wrapper Classes

Convert primitive to object type and vice versa.

| Primitive | Wrapper Class |
|-----------|---------------|
| byte | Byte |
| short | Short |
| int | Integer |
| long | Long |
| float | Float |
| double | Double |
| char | Character |
| boolean | Boolean |

### Autoboxing & Unboxing

```java
public class WrapperExample {
    public static void main(String[] args) {
        int x = 100;
        Integer num = x; // Autoboxing (primitive → object)

        int n = num; // Unboxing (object → primitive)
    }
}
```

### String Conversions

```java
int num = 100;
String str = String.valueOf(num); // Primitive → String
// OR
String str2 = Integer.toString(num);

String str3 = "123";
int num2 = Integer.parseInt(str3); // String → Primitive
```

## Type Casting

Converting one data type to another.

### Implicit (Widening) Casting
```java
int num = 100;
double d = num; // Automatic conversion
```

### Explicit (Narrowing) Casting
```java
double d = 99.99;
int num = (int) d; // Manual casting
```

### Object Type Casting
```java
Object o = new String("welcome");
String s = (String) o; // Valid casting
```

## Exception Handling

Exception is an event that causes program termination.

### Types of Exceptions

1. **Checked Exceptions** (Compile-time)
   - FileNotFoundException, IOException

2. **Unchecked Exceptions** (Runtime)
   - ArithmeticException, NullPointerException, ArrayIndexOutOfBoundsException

### try-catch-finally

```java
try {
    // Code that might throw exception
} catch (ExceptionType e) {
    // Handle exception
} finally {
    // Always executes
}
```

### Example
```java
public class ExceptionHandlingExample {
    public static void main(String[] args) {
        try {
            int[] arr = {1, 2, 3};
            System.out.println(arr[5]); // ArrayIndexOutOfBoundsException
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Array index is out of bounds: " + e.getMessage());
        } finally {
            System.out.println("This will always execute.");
        }
    }
}
```

## Collections Framework

### ArrayList
Resizable array, allows duplicates, maintains insertion order.

```java
import java.util.ArrayList;

public class ArrayListExample {
    public static void main(String[] args) {
        ArrayList<String> myList = new ArrayList<String>();

        // Adding elements
        myList.add("Alice");
        myList.add("25");
        myList.add("3.14");
        myList.add("true");
        myList.add("A");
        myList.add(null);
        myList.add("25"); // Duplicate allowed
        myList.add("Alice"); // Duplicate allowed

        // Inserting at specific index
        myList.add(2, "Inserted Element");

        // Accessing elements
        System.out.println("Element at index 3: " + myList.get(3));

        // Updating
        myList.set(1, "99");

        // Removing
        myList.remove(4);
        myList.remove("Alice");

        // Checking
        System.out.println("Contains '3.14'? " + myList.contains("3.14"));
        System.out.println("Size: " + myList.size());
        System.out.println("Is empty? " + myList.isEmpty());

        // Iterating
        for (String item : myList) {
            System.out.println(item);
        }
    }
}
```

### HashSet
No duplicates, unordered, fast operations.

```java
import java.util.HashSet;

public class HashSetDemo {
    public static void main(String[] args) {
        HashSet myset = new HashSet();

        // Adding elements
        myset.add(100);
        myset.add(10.5);
        myset.add("welcome");
        myset.add(true);
        myset.add('A');
        myset.add(100); // Duplicate - not added
        myset.add(null);
        myset.add(null); // Only one null allowed

        System.out.println(myset); // Unordered output
        System.out.println("Size: " + myset.size());

        // Removing
        myset.remove(10.5);

        // Iterating
        for (Object x : myset) {
            System.out.println(x);
        }
    }
}
```

### HashMap
Key-value pairs, unique keys, fast lookup.

```java
import java.util.HashMap;

public class HashMapDemo {
    public static void main(String[] args) {
        HashMap<Integer, String> hm = new HashMap<>();

        // Adding key-value pairs
        hm.put(101, "John");
        hm.put(102, "Scott");
        hm.put(103, "Mary");
        hm.put(104, "Scott"); // Duplicate value allowed
        hm.put(102, "David"); // Overwrites previous value

        System.out.println(hm); // Unordered

        // Accessing
        System.out.println(hm.get(102)); // David

        // Getting keys and values
        System.out.println("Keys: " + hm.keySet());
        System.out.println("Values: " + hm.values());

        // Iterating
        for (Integer k : hm.keySet()) {
            System.out.println(k + " " + hm.get(k));
        }

        // Removing
        hm.remove(103);

        // Size
        System.out.println("Size: " + hm.size());
    }
}
```

## Collections Comparison

| Feature | ArrayList | HashSet | HashMap |
|---------|-----------|---------|---------|
| Interface | List | Set | Map |
| Duplicates | Allowed | Not allowed | Keys: Not allowed<br>Values: Allowed |
| Order | Insertion order preserved | Not preserved | Not preserved |
| Null values | Multiple allowed | One null | One null key, multiple null values |
| Access | By index | No indexing | By key |

## Important Interview Questions

### Q: Difference between == and .equals()?
- **==**: Compares memory addresses (Reference comparison)
- **.equals()**: Compares actual content (Content comparison)

```java
String a = new String("Java");
String b = new String("Java");
System.out.println(a == b); // false
System.out.println(a.equals(b)); // true
```

### Q: Difference between Method Overloading vs Overriding?

| Feature | Method Overloading | Method Overriding |
|---------|-------------------|-------------------|
| Occurs in | Same class | Parent-Child classes |
| Parameters | Must be different | Must be same |
| Return type | Can be different | Must be same |
| When | Compile-time | Runtime |
| @Override | Not required | Recommended |

### Q: Why multiple inheritance not possible in Java?
Java doesn't support multiple inheritance with classes to avoid the Diamond Problem (ambiguity when two parent classes have same method).

### Q: final vs finally vs finalize?

| Keyword | Purpose | Usage |
|---------|---------|-------|
| final | Constants, prevent overriding/inheritance | final int x = 10; |
| finally | Exception handling cleanup | try-catch-finally |
| finalize | Garbage collection cleanup | Called by JVM before object destruction |

---

**This comprehensive guide covers all essential OOP concepts for SDET interviews and practical Java development!** 🚀
