package world.clock;

import com.ulisesbocchio.jasyptspringboot.annotation.EnableEncryptableProperties;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.web.client.RestTemplate;
import org.modelmapper.ModelMapper;

@SpringBootApplication //(exclude = {SecurityAutoConfiguration.class })
@EnableAutoConfiguration
@EnableEncryptableProperties
public class Application {

	public static void main(String[] args) {
		new SpringApplicationBuilder(Application.class).build().run(args);
		String tmpdir = System.getProperty("java.io.tmpdir");
		System.out.println("Temp file path: " + tmpdir);
		//SpringApplication.run(Application.class, args);
	}

	@Bean
	public ModelMapper modelMapper() {
		return new ModelMapper();
	}

	@Bean
	public RestTemplate createRestTemplate() {
		return new RestTemplate();
	}

}
