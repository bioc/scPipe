#include <testthat.h>
#include <cstring>
#include <iostream>
#include "utils.h"
#include <Rcpp.h>
context("String memory functions") {
    test_that("String memory allocation works") {
        char* str = str_alloc(10);
        std::strncpy(str, "abcdefghij", 10);
        
        Rcpp::Rcout << str << " " << strlen(str) << std::endl;

        // check that string has been placed into allocated memory
        expect_true(str != NULL);
        expect_true(strlen(str) == 10);
        expect_true(str[0] == 'a');
        expect_true(str[9] == 'j');
        expect_true(str[10] == '\0');
        
        expect_error(str_alloc(-1));
        
        free(str);
    }
    
    test_that("String memory reallocation works") {
        char* str = str_alloc(10);
        std::strncpy(str, "abcdefghij", 10);
        str = str_realloc(str, 15);
        
        // check that string has been retained in reallocated memory
        expect_true(str != NULL);
        expect_true(str[0] == 'a');
        expect_true(str[9] == 'j');
        expect_true(str[10] == '\0');
        expect_true(strlen(str) == 10);

        expect_error(str_realloc(str, -1));
    }
    
    test_that("String shifting works") {
        char* str = str_alloc(10);
        std::strncpy(str, "abcdefghij", 10);    
        str = str_shift(str, 5);
        
        // check that string has been shifted
        expect_true(str != NULL);
        expect_true(strlen(str) == 15);
        expect_true(str[5] == 'a');
        expect_true(str[15] == '\0');

        // check old data still present
        expect_true(str[0] == 'a');
        expect_true(str[4] == 'e');
        

        expect_error(str_shift(str, -1));
    }
}