exports.config = {
	// Framework to use
	framework: 'jasmine',

	// Options to be passed to Jasmine-node.
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000 // 30s
  },

  // Default timeout
  allScriptsTimeout: 30000, // 30s

  // The address of a running selenium server.
  seleniumAddress: 'http://localhost:4444/wd/hub',

  // The address where the tests start from
  baseUrl: '',

  // Spec files
  specs: [
    'spec-files/*/*-spec.js'
  ],

  // Test suites
  suites: {
    index: 'spec-files/index-suite/*.js',
    about: 'spec-files/about-suite/*.js',
    signup: 'spec-files/signup-suite/*.js',
    signin: 'spec-files/signin-suite/*.js'
  },

  // Capabilities to be passed to the webdriver instance.
  capabilities: {
    browserName: 'chrome',
    chromeOptions: {
      'args': ['--headless', '--disable-gpu']
    }
  }
 
  // In case you want to use multiple browser instances.
  // Replace capabilities to:
  /*multiCapabilities: [{
    browserName: 'firefox',
    'moz:firefoxOptions': {
      args: ['--headless']
    }
  }, {
    browserName: 'chrome',
    chromeOptions: {
      args: ['--headless', '--disable-gpu']
    }
  }]*/

};
