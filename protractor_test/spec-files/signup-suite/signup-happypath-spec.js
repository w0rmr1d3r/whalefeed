/*
Whalefeed test
SignUp Component
@author rguimera
*/
describe('Whalefeed - SignUpComponent Happy Path', function() {
  var signUpLink = element(by.linkText('Sign up!'));
  var signUpTitle = element(by.xpath('//*[@id="greeny-main-page-section"]/h2'));
  var signUpButton = element(by.buttonText('Sign up!'));
  var usernameInput = element(by.id('username'));
  var emailInput = element(by.id('email'));
  var passwordInput = element(by.id('password'));
  var passwordRepeatInput = element(by.id('passwordrepeat'));
  var signInTitle = element(by.xpath('//*[@id="greeny-main-page-section"]/h2'));

  /*
	User to sign up data
  */
  var username = 'protractoruser';
  var email = 'protractoruser@test.com';
  var password = '12345678';
  var passwordRepeat = '12345678';

  beforeEach(function() {
    browser.get('');
    signUpLink.click();
  });

  it('See the form correctly', function(){
  	expect(usernameInput.isDisplayed()).toBe(true);
  	expect(emailInput.isDisplayed()).toBe(true);
  	expect(passwordInput.isDisplayed()).toBe(true);
  	expect(passwordRepeatInput.isDisplayed()).toBe(true);
  	expect(signUpButton.isDisplayed()).toBe(true);
  	expect(signUpButton.isEnabled()).toBe(false);
  });

  it('Sign up new user', function() {
  	// enter inputs
  	usernameInput.sendKeys(username);
  	emailInput.sendKeys(email);
  	passwordInput.sendKeys(password);
  	passwordRepeatInput.sendKeys(passwordRepeat);
  	expect(signUpButton.isEnabled()).toBe(true);
  	signUpButton.click();

  	// wait
    browser.wait(
    	protractor.ExpectedConditions
    	  .textToBePresentInElement(signInTitle, 'Sign in!'),
    	20 * 1000,
    	'Waiting for sign up process');

  	// see sign in
  	expect(signInTitle.getText()).toEqual('Sign in!');
  });

});
