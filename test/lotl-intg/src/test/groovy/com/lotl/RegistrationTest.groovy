package com.lotl;

import org.junit.Test;
import static org.junit.Assert.*
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.WebDriverWait;

public class RegistrationTest {

	@Test
	public void testRegistrationPage() {

		WebDriver driver = new FirefoxDriver();
		driver.get("https://localhost");
		def element = driver.findElement(By.cssSelector("div.ltl-login-form > p > a"))
		element.click();

		(new WebDriverWait(driver, 1)).until(new ExpectedCondition<Boolean>() {
					public Boolean apply(WebDriver d) {
						def body = d.findElement(By.tagName("body"))
						body != null
					}
				});

		def txtUser = driver.findElement(By.id("user_email"))
		def txtPwd = driver.findElement(By.id("user_password"))
		assertNotNull txtUser
		assertNotNull txtPwd
		driver.quit();
	}


}
