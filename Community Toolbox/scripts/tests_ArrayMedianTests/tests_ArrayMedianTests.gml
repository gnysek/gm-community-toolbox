function ArrayMedianTests(_run, _method) : VerrificMethodTest(_run, _method) constructor {
    static test_subject = "array_median";
    
    // testing for especially large arrays,
    // because original script_execute_ext(...) implementation crashed on stack overflow with ~60k items,
    // so testing arrays/subsections with over ~65536 items should catch issues with naive script_execute_ext(...) implementation
    static array_with_100k_items = array_create_ext(100_000, function(i) { return i; });
    
    static should_handle_empty_array = function() {
        given_array([]);
        when_array_median_runs();
        then_result().should_be(0);
    }
    
    static should_handle_one_entry_array = function() {
        given_array([7]);
        when_array_median_runs();
        then_result().should_be(7);
    }
    
    static should_handle_even_entry_array = function() {
        //Implementation note: GM's median() takes higher of two middle entries
        given_array([5, -5, 3, 10]);
        when_array_median_runs();
        then_result().should_be(5);
    }
    
    static should_handle_odd_entry_array = function() {
        given_array([7, -5, 0, 3, 10]);
        when_array_median_runs();
        then_result().should_be(3);
    }
    
    static should_handle_large_array = function() {
        given_array(array_with_100k_items);
        when_array_median_runs();
        then_result().should_be(50_000);
    }
    
    static should_handle_offset_only = function() {
        given_array([4, 6, 5, 1, 3, 2]);
        given_offset(3); // should take [1, 3, 2]
        when_array_median_runs();
        then_result().should_be(2);
    }
    
    static should_handle_positive_offset_and_length = function() {
        given_array([1, 6, 2, 7, 3, 8, 4, 9, 5, 0]);
        given_offset_and_length(3, 4); // should take [7, 3, 8, 4]
        when_array_median_runs();
        then_result().should_be(7);
    }
    
    static should_handle_negative_offset = function() {
        given_array([1, 6, 2, 7, 3, 8, 4, 9, 5, 0]);
        given_offset_and_length(-5, 3); // should take [8, 4, 9]
        when_array_median_runs();
        then_result().should_be(8);
    }
    
    static should_handle_negative_length = function() {
        given_array([1, 6, 2, 7, 3, 8, 4, 9, 5, 0]);
        given_offset_and_length(5, -3); // should take [8, 3, 7]
        when_array_median_runs();
        then_result().should_be(7);
    }
    
    static should_handle_large_subsection = function() {
        given_array(array_with_100k_items);
        given_offset_and_length(20_000, 70_000); // should take [20000, 20001, ..., 89998, 89999]
        when_array_median_runs();
        then_result().should_be(55_000);
    }
    
    static should_handle_overshooting = function() {
        given_array([1, 6, 2, 7, 3, 8, 4, 9, 5, 0]);
        given_offset_and_length(7, 5); // should take [9, 5, 0]
        when_array_median_runs();
        then_result().should_be(5);
    }
    
    static should_handle_large_array_overshooting = function() {
        given_array(array_with_100k_items);
        given_offset_and_length(90_000, 20_000); // should take [90000, 90001, ..., 99998, 99999]
        when_array_median_runs();
        then_result().should_be(95_000);
    }
    
    // -----
    // Setup
    // -----
    
    array = [];
    offset = undefined;
    length = undefined;
    result = undefined;
    
    static given_array = function(_array) {
        array = _array;
    }
    
    static given_offset = function(_offset) {
        offset = _offset;
    }
    
    static given_offset_and_length = function(_offset, _length) {
        offset = _offset;
        length = _length;
    }
    
    static when_array_median_runs = function() {
        if (is_undefined(offset))
            result = array_median(array);
        else if (is_undefined(length))
            result = array_median(array, offset);
        else
            result = array_median(array, offset, length);
    }
    
    static then_result = function() {
        return new VerrificNumericAssertion(test_asserter, result);
    }
}
