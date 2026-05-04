# Interface Design for Testability

Good interfaces make testing natural:

1. **Accept dependencies, don't create them**

   ```ruby
   # Testable
   def process_order(order, payment_gateway)
   end

   # Hard to test
   def process_order(order)
     gateway = StripeGateway.new
   end
   ```

2. **Return results, don't produce side effects**

   ```ruby
   # Testable
   def calculate_discount(cart)
     # returns a Discount object
   end

   # Hard to test
   def apply_discount(cart)
     cart.total -= discount
   end
   ```

3. **Small surface area**
   - Fewer methods = fewer tests needed
   - Fewer params = simpler test setup
