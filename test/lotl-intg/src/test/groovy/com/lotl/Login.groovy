package com.lotl;

import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.WebDriverWait;

public class Login {

	@Test
	public void testIncorrectLogin() {

		WebDriver driver = new FirefoxDriver();
		driver.get("https://localhost");
		def element = driver.findElement(By.cssSelector("div.ltl-login-form > p > a"))
		element.click();

		(new WebDriverWait(driver, 20)).until(new ExpectedCondition<Boolean>() {
					public Boolean apply(WebDriver d) {
						def el = d.findElement(By.id(("user_email")))
						return el != null;
					}
				});

		driver.quit();
	}


}
