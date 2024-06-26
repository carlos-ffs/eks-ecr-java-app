package world.clock.web;
import javax.naming.NamingException;

import org.apache.catalina.loader.WebappClassLoaderBase;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.jndi.JndiLocatorDelegate;
import org.springframework.util.StringUtils;
import world.clock.Application;


/**
 * Starts the application. This will be run, if the app was started in a dedicated server, like Tomcat or Jetty.
 */
public class ServletInitializer extends SpringBootServletInitializer {

    private final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(this.getClass());

    private final JndiLocatorDelegate jndi = JndiLocatorDelegate.createDefaultResourceRefLocator();

    @Override
    protected SpringApplicationBuilder configure(final SpringApplicationBuilder application) {
        log.info("Starting Clock API application (from Tomcat starter) ...");

        String contextName = ((WebappClassLoaderBase) application.application().getClassLoader()).getContextName();
        if (StringUtils.isEmpty(contextName)) {
            contextName = "UnknownContextName";
        } else if (contextName.equalsIgnoreCase("ROOT")) {
            contextName = "/";
        }
        log.info("The applications servlet context name is set to \"{}\"", contextName);

        // SET SERVER PROFILE:
        String profile;
        try {
            profile = this.jndi.lookup("SPRING_PROFILES_ACTIVE", String.class);
            System.setProperty("spring.profiles.active", profile.toLowerCase());
            this.log.info("JNDI server side profiles: {}", profile);
        } catch (final NamingException e1) {
            this.log.info("Could not resolve serverside profiles from JNDI by name \"SPRING_PROFILES_ACTIVE\": {}", e1.getMessage());
            try {
                profile = this.jndi.lookup("STAGE", String.class);
                System.setProperty("spring.profiles.active", profile.toLowerCase());
                this.log.info("JNDI server side profiles: {}", profile);
            } catch (final NamingException e2) {
                this.log.error("Could not resolve serverside profiles from JNDI: {}", e2.getMessage());
            }
        }
        return application.listeners().sources(Application.class);
    }
}
