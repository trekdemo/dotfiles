# Good and Bad Tests

## Good Tests

**Integration-style**: Test through real interfaces, not mocks of internal parts.

```ruby
# GOOD: Tests observable behavior
it "user can checkout with valid cart" do
  cart = create_cart
  cart.add(product)
  result = checkout(cart, payment_method)
  expect(result.status).to eq("confirmed")
end
```

Characteristics:

- Tests behavior users/callers care about
- Uses public API only
- Survives internal refactors
- Describes WHAT, not HOW
- One logical assertion per test

## Bad Tests

**Implementation-detail tests**: Coupled to internal structure.

```ruby
# BAD: Tests implementation details
it "checkout calls payment_service.process" do
  mock_payment = instance_double(PaymentService)
  allow(PaymentService).to receive(:new).and_return(mock_payment)
  allow(mock_payment).to receive(:process)
  checkout(cart, payment)
  expect(mock_payment).to have_received(:process).with(cart.total)
end
```

Red flags:

- Mocking internal collaborators
- Testing private methods
- Asserting on call counts/order
- Test breaks when refactoring without behavior change
- Test name describes HOW not WHAT
- Verifying through external means instead of interface

```ruby
# BAD: Bypasses interface to verify
it "create_user saves to database" do
  create_user(name: "Alice")
  row = db.query("SELECT * FROM users WHERE name = ?", ["Alice"])
  expect(row).to be_defined
end

# GOOD: Verifies through interface
it "create_user makes user retrievable" do
  user = create_user(name: "Alice")
  retrieved = get_user(user.id)
  expect(retrieved.name).to eq("Alice")
end
```
