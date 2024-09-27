# Assertive
A Jai module of simple assert helpers. Useful for unit testing, or just improved assert output in general code.

![image](https://github.com/user-attachments/assets/cd8c4312-eee2-4269-be77-e5617a05b185)

## Basic Usage

```jai
server_test :: () {
    log("\n--- Server ---------------------------------------------------------------------\n");
    log("Running tests...\n");
    assert_test(test_server_send_packet);
    assert_test(test_server_receive_packet);
    log("Passed!\n");
}

#scope_file

#import "Basic";
#import "Assertive";

test_server_send_packet :: () {
    packets_sent := 42;
    recipient := "127.0.0.1";
    packets_sent_ptr := *packets_sent;

    assert_equal(packets_sent, 42);
    assert_equal(recipient, "127.0.0.1");
    assert_not_null(packets_sent_ptr);
    assert_equal(packets_sent_ptr.*, packets_sent);
}

test_server_receive_packet :: () {
    an_array := int.[ 1, 2, 3, 4, 5 ];
    another_array := int.[ 1, 2, 3, 7, 5 ];

    // arrays are special, and will print pretty details if their counts or elements don't match
    assert_equal(an_array, another_array);
}
```

## Example Output

```
--- Server ---------------------------------------------------------------------
Running tests...
┌──────────────────────────────────────────────────────────────────────────────┐
│ [Test] test_server_send_packet                                               │
└──────────────────────────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────────────────────────┐
│ [Test] test_server_receive_packet                                            │
└──────────────────────────────────────────────────────────────────────────────┘
c:/Users/User/Documents/MyProject/modules/FakeModule.jai:30,5: Assertion failed: assert_equal(an_array, another_array)

Element at index 3 is different:
value    : 4
expected : 7

In arrays:
value    [1, 2, 3, 4, 5]
expected [1, 2, 3, 7, 5]

Stack trace:
C:/Program Files/jai/modules/Runtime_Support.jai:103: runtime_support_assertion_failed
C:/Program Files/jai/modules/Basic/module.jai:87: assert_helper
c:/Users/User/Documents/MyProject/modules/Assertive.jai:56: assert_equal
c:/Users/User/Documents/MyProject/modules/FakeModule.jai:30: test
c:/Users/User/Documents/MyProject/modules/FakeModule.jai:5: server_test
```
