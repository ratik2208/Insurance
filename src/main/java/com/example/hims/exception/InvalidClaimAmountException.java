package com.example.hims.exception;

public class InvalidClaimAmountException extends RuntimeException {
    public InvalidClaimAmountException(String message) {
        super(message);
    }
}
