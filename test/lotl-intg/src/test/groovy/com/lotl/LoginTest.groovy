package com.lotl;

import org.junit.Test
import static org.junit.Assert.*;
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver
import org.openqa.selenium.support.ui.ExpectedCondition
import org.openqa.selenium.support.ui.WebDriverWait

public class LoginTest {
	
	@Test
	public void testSuccessfulLogin() {
		WebDriver driver = new FirefoxDriver();
		driver.get("https://localhost");
		def form = driver.findElement(By.cssSelector("div.container div.ltl-login-form form"));
		def txtEmail = form.findElement(By.name("email"))
		txtEmail.sendKeys("marc@email.com")
		def txtPwd = form.findElement(By.name("password"))
		txtPwd.sendKeys("password")
		form.submit()
		
		(new WebDriverWait(driver, 1)).until(new ExpectedCondition<Boolean>() {
			public Boolean apply(WebDriver d) {
				def body = d.findElement(By.tagName("body"))
				body != null
			}
		});
	
		def heading = driver.findElement(By.cssSelector("div.container div.ltl-projects-list h2.heading"))
		assertNotNull heading
		assertEquals("Your Projects", heading.getText())
		driver.quit()
	}
	
	@Test
	public void testUnsuccessfulLogin() {
		assertTrue true
		//WebDriver driver = new FirefoxDriver();
		//driver.get("https://localhost");
	}

}
