const ErrorResponse = (res, message, statusCode) => {
  res.status(statusCode).json({
    error: {
      message,
      statusCode,
    },
  });
};

module.exports = ErrorResponse;
