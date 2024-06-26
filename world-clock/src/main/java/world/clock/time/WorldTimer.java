package world.clock.time;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Service;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;


@Service
public class WorldTimer {

	private static final Logger logger = LoggerFactory.getLogger(WorldTimer.class);

    public WorldTimer(){}

    private DateTimeFormatter formatter;

	@PostConstruct
	void loadFormatterZones() throws InterruptedException {
        formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss z");
	}

    public String getCurrentTimeHTML(){
        ZonedDateTime newYorkTime = ZonedDateTime.now(ZoneId.of("America/New_York"));
        ZonedDateTime berlinTime = ZonedDateTime.now(ZoneId.of("Europe/Berlin"));
        ZonedDateTime tokyoTime = ZonedDateTime.now(ZoneId.of("Asia/Tokyo"));


        return "<html>" +
                "<body>" +
                "<h1>Current Local Times</h1>" +
                "<p>New York: " + newYorkTime.format(formatter) + "</p>" +
                "<p>Berlin: " + berlinTime.format(formatter) + "</p>" +
                "<p>Tokyo: " + tokyoTime.format(formatter) + "</p>" +
                "</body>" +
                "</html>";

    }

}
