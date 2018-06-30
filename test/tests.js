// Tests runner.

// Unit tests
require('./bet_kernel.js');

require('./BetPayments/bet_payments.js');
require('./BetPayments/bet_payments_exceptions.js');

require('./BetTerms/owner_based.js');

// Integration tests
require('./bet_integration_tests.js');
