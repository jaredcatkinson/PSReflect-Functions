<#
.SYNOPSIS

The OBJECT_ATTRIBUTES structure specifies attributes that can be applied to objects or object handles by routines that create objects and/or return handles to objects.

.NOTES

Author: Jared Atkinson (@jaredcatkinson), Brian Reitz (@brian_psu)
License: BSD 3-Clause
Required Dependencies: PSReflect
Optional Dependencies: None

typedef struct _OBJECT_ATTRIBUTES {
  ULONG           Length;
  HANDLE          RootDirectory;
  PUNICODE_STRING ObjectName;
  ULONG           Attributes;
  PVOID           SecurityDescriptor;
  PVOID           SecurityQualityOfService;
}  OBJECT_ATTRIBUTES, *POBJECT_ATTRIBUTES;

.LINK

https://msdn.microsoft.com/en-us/library/windows/hardware/ff557749(v=vs.85).aspx
#>

$OBJECT_ATTRIBUTES = struct $Module OBJECT_ATTRIBUTES @{
    Length = field 0 UInt32
    RootDirectory = field 1 IntPtr
    ObjectName = field 2 $UNICODE_STRING.MakeByRefType()
    Attributes = field 3 UInt32
    SecurityDescriptor = field 4 IntPtr
    SecurityQualityOfService = field 5 IntPtr
    }
