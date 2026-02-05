# Object Oriented ABAP [05th February, 2026]. 

## Class & Objects
Class is a template of an object. Is is an abstract concept.

### Attributes:
Four pillars of OOPS.

> SNOTES  

### Class Definition and Implementation.
```
CLASS <class_name> DEFINITION.
<code>
ENDCLASS.

CLASS <class_name> IMPLEMENTATION.
    METHOD M1
        <code>
    ENDMETHOD.
ENDCLASS.
```
  
Who can use a class?  
Class Itself, Subclass (Inheritance), External User (Via Object).

### Sections of a Class.
- In SAP, no default visibility section in a class.
- The sequence of visibility must be maintained in a class.  
    - Public
    - Protected
    - Private

> Order for sections: PRIVATE SECTION, PROTECTED SECTION, PUBLIC SECTION. 

> **Friend Class:** 

### Components of a Class:
- Attributes: Any data constants, types declared within a class form the attribute of the class.
- Methods: Block of code, providing some functionality.
- Events: A mechanism set within a class which can help 
- Interfaces:

If class- mentioned then static else instance.

### Methods 
1. Declaring:
```
METHODS: <method_name> ...
ENDMETHOD.
```
2. Usage:
```
METHOD <method_name>.
```

### Creating an Object.
1. Create a reference variable with reference to the class.
```
DATA: <object_name> TYPE REF TO <class_name>.
```
2. Create an object from the reference variable.
```
CREATE OBJECT <object_name>.
```

> REFER TO ZUSERABAP_CLASS_DEMO
```
New Syntax to create Object.
DATA(lo_sflight) = NEW lcl_flight_data().

lo_flight->fetch_data( ).
lo_flight->display_data( ).
```

> **IN CLASS ASSIGNMENT:** 1 method to extract - VBAK, 2 method to extract VBAP based on VBAK, 3rd Method - Construct final output based on VBAK data and VBAP data together. (Minimum 7 fields from each table, VBELN common to make 13 for 3rd), 4th Method for display only M3.

1. Package: Create Z34_OOABAP Package.
2. Create a different Transport Request, Desc: USERNAME34 - 05/02/2026 - OOABAP
3. When we will create our program, should be saved on transport request.

ZUSERABAP34_OO
USERNAME34 - 05/02/2026 - OOABAP

~ Study Instance v/s Static ~