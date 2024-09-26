assert_test :: (test: (), $log_header := true, call := #caller_code) #expand {
    #if log_header {
        arg0 :: #run get_argument_name(call);
        spaces :: #run -> string {
            space_count := (80 - arg0.count - 10);
            builder: String_Builder;
            for 0..space_count-1 {
                append(*builder, #char " ");
            }
            return builder_to_string(*builder);
        };

TEST_HEADER :: #string EOS
┌──────────────────────────────────────────────────────────────────────────────┐
│ [Test] %0%│
└──────────────────────────────────────────────────────────────────────────────┘
EOS

        log(TEST_HEADER, arg0, spaces);
    }

    test();
}

assert_true :: (value: bool, $call := #caller_code, loc := #caller_location) {
    if value != true {
        assert(false, "%\nValue is false.\nvalue : %", #run get_expression(call), value, loc = loc);
    }
}

assert_false :: (value: bool, $call := #caller_code, loc := #caller_location) {
    if value != false {
        assert(false, "%\nValue is not false.\nvalue : %", #run get_expression(call), value, loc = loc);
    }
}

assert_null :: (value: $T, $call := #caller_code, loc := #caller_location) {
    if value != null {
        assert(false, "%\nValue is not null.\nvalue : %", #run get_expression(call), value, loc = loc);
    }
}

assert_not_null :: (value: $T, $call := #caller_code, loc := #caller_location) {
    if value == null {
        assert(false, "%\nValue is null.", #run get_expression(call), loc = loc);
    }
}

assert_equal :: (value: T, expected: $T, $call := #caller_code, loc := #caller_location) {
    #if type_info(T).type == .ARRAY {
        if value.count != expected.count {
            assert(false, "%\nArray length does not match.\nvalue    : %\nexpected : %", #run get_expression(call), value.count, expected.count, loc = loc);
        }
        for 0..value.count-1 {
            if value[it] != expected[it] {
                assert(false, "%\n\nElement at index % is different:\nvalue    : %\nexpected : %\n\nIn arrays:\nvalue    %\nexpected %", #run get_expression(call), it, value[it], expected[it], value, expected, loc = loc);
            }
        }
    } else {
        if value != expected {
            assert(false, "%\nvalue    : %\nexpected : %", #run get_expression(call), value, expected, loc = loc);
        }
    }
}

assert_not_equal :: (value: T, expected: $T, $call := #caller_code, loc := #caller_location) {
    if value == expected {
        assert(false, "%\nvalue    : %\nexpected : %", #run get_expression(call), value, expected, loc = loc);
    }
}

/*
assert_equal :: (comparator: (T, T) -> bool, value: T, expected: $T, $call := #caller_code, loc := #caller_location) {
    if !comparator(value, expected) {
        assert(false, "%\nvalue    : %\nexpected : %", #run get_expression(call), value, expected, loc = loc);
    }
}
*/

#scope_file

#import "Basic";

get_expression :: (call := #caller_code) -> string {
    #import "Compiler";
    #import "Program_Print";

    root := compiler_get_nodes(call);
    builder: String_Builder;
    print_expression(*builder, root);
    return builder_to_string(*builder);
};

get_argument_name :: (call: Code, index := 0) -> string {
    #import "Compiler";

    root := compiler_get_nodes(call);
    if root.kind == .PROCEDURE_CALL {
        proc_call := cast(*Code_Procedure_Call) root;
        arg := cast(*Code_Ident) proc_call.arguments_sorted[index];
        return arg.name;
    } else {
        err :: "expected a procedure code node";
        assert(false, err);
        return err;
    }
};
