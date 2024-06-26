package world.clock.web.controller;

import world.clock.time.WorldTimer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;


@Controller
@RequestMapping(path = "/")
public class ClockController {

    private final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(ClockController.class);

    @Autowired
    @Qualifier("worldTimer")
    WorldTimer timer;

    public ClockController() {
        this.log.debug("New {}", this.getClass().getSimpleName());
    }

    @ResponseBody
    @GetMapping(path = { "", "/" }, produces = MediaType.TEXT_HTML_VALUE)
    public String indexHTML() {
        return timer.getCurrentTimeHTML();
    }
}
