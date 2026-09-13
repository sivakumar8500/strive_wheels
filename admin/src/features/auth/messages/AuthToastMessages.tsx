export const MESSAGES = {
  AUTH: {
    LOGIN_SUCCESS: "Successfully logged in!",
    LOGIN_FAILURE:
      "Incorrect password. You have 2 attempts remaining before your account is blocked.",
    LOGOUT_SUCCESS: "You have been logged out.",

    REGISTER_SUCCESS: "Registration successful! Please login.",
    REGISTER_FAILURE: "Failed to register. Please try again.",
    REGISTER_ALREADY_COMPLETED:
      "Registration already completed. Please log in using your existing password.",

    FORGOT_SUCCESS: "We have sent an OTP to your inbox!",
    FORGOT_FAILURE: "The email you entered is incorrect. Please try again.",

    VERIFY_OTP_SUCCESS: "OTP verified successfully!",
    VERIFY_OTP_FAILURE: "Invalid or expired OTP. Please try again.",

    RESEND_OTP_SUCCESS: "Resend OTP to you inbox!",
    RESEND_OTP_FAILURE: "Invalid or expired OTP. Please try again.",

    RESET_PASSWORD_SUCCESS: "Your password has been reset successfully!",
    RESET_PASSWORD_FAILURE: "Unable to reset password. Please try again.",
  },
} as const;
