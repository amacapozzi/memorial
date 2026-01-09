import { USER_ERROR_CODE } from "@shared/errors/user/user-error";

export interface UserError {
  status: number;
  code: USER_ERROR_CODE;
  message: string;
}

export const USER_ERRORS: Record<USER_ERROR_CODE, UserError> = {
  [USER_ERROR_CODE.NOT_FOUND]: {
    status: 404,
    code: USER_ERROR_CODE.NOT_FOUND,
    message: "User not found"
  },

  [USER_ERROR_CODE.ALREADY_EXISTS]: {
    status: 409,
    code: USER_ERROR_CODE.ALREADY_EXISTS,
    message: "User already exists"
  },

  [USER_ERROR_CODE.INVALID_CREDENTIALS]: {
    status: 401,
    code: USER_ERROR_CODE.INVALID_CREDENTIALS,
    message: "Invalid credentials"
  },

  [USER_ERROR_CODE.UNAUTHORIZED]: {
    status: 401,
    code: USER_ERROR_CODE.UNAUTHORIZED,
    message: "Unauthorized access"
  },

  [USER_ERROR_CODE.FORBIDDEN]: {
    status: 403,
    code: USER_ERROR_CODE.FORBIDDEN,
    message: "You do not have permission to perform this action"
  },

  [USER_ERROR_CODE.VALIDATION_ERROR]: {
    status: 422,
    code: USER_ERROR_CODE.VALIDATION_ERROR,
    message: "Validation error"
  },

  [USER_ERROR_CODE.INTERNAL_ERROR]: {
    status: 500,
    code: USER_ERROR_CODE.INTERNAL_ERROR,
    message: "Internal server error"
  }
};
