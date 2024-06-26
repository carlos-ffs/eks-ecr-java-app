package world.clock.web.controller;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.core.JsonProcessingException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.ServletRequestAttributes;


@Controller
@RequestMapping("/error")
public class ErrorWebController implements ErrorController {

    private final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(ErrorWebController.class);

    @SuppressWarnings("squid:S3752") // error handler need to handle multiple methods the same way
    @RequestMapping(produces = "application/json", method = { RequestMethod.GET, RequestMethod.POST, RequestMethod.OPTIONS })
    @ResponseBody
    public ResponseEntity<Object> errorJsonClient(final HttpServletRequest request) throws JsonProcessingException {
        final ErrorMessage errorMessage = this.getErrorMessage(request);
        return new ResponseEntity<>(errorMessage, errorMessage.status);
    }

    private ErrorMessage getErrorMessage(final HttpServletRequest request) {
        final Integer statusCode = (Integer) request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        final Throwable exceptionValue = (Throwable) request.getAttribute(RequestDispatcher.ERROR_EXCEPTION);
        final HttpStatus httpStatus = statusCode == null ? HttpStatus.INTERNAL_SERVER_ERROR : HttpStatus.resolve(statusCode);
        return new ErrorMessage(httpStatus, exceptionValue);
    }

    @SuppressWarnings("unused")
    private class ErrorMessage {

        @JsonIgnore
        HttpStatus status;
        public final int value;
        public final String message;
        public final String exception;

        public ErrorMessage(final HttpStatus status, final Throwable exception) {
            this.status = status;
            this.value = status.value();
            this.message = status.getReasonPhrase();
            this.exception = exception != null ? exception.getMessage() : null;
        }
    }
    public String getErrorPath() {
        return "/error";
    }
}
