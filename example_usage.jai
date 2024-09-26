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
    another_array := int.[ 1, 2, 3, 4, 5 ];

    // arrays are special, and will print pretty details if their counts or elements don't match
    assert_equal(an_array, another_array);
}
