# When to Mock

Mock at **system boundaries** only:

- External APIs (payment, email, etc.)
- Databases (sometimes - prefer test DB)
- Time/randomness
- File system (sometimes)

Don't mock:

- Your own classes/modules
- Internal collaborators
- Anything you control

## Designing for Mockability

At system boundaries, design interfaces that are easy to mock:

**1. Use dependency injection**

Pass external dependencies in rather than creating them internally:

```ruby
# Easy to mock
def process_payment(order, payment_client)
  payment_client.charge(order.total)
end

# Hard to mock
def process_payment(order)
  client = StripeClient.new(ENV['STRIPE_KEY'])
  client.charge(order.total)
end
```

**2. Prefer SDK-style interfaces over generic fetchers**

Create specific methods for each external operation instead of one generic method with conditional logic:

```ruby
# GOOD: Each method is independently mockable
class API
  def get_user(id)
    http_client.get("/users/#{id}")
  end

  def get_orders(user_id)
    http_client.get("/users/#{user_id}/orders")
  end

  def create_order(data)
    http_client.post("/orders", data)
  end
end

# BAD: Mocking requires conditional logic inside the mock
class API
  def fetch(endpoint, options)
    http_client.request(endpoint, options)
  end
end
```

The SDK approach means:
- Each mock returns one specific shape
- No conditional logic in test setup
- Easier to see which endpoints a test exercises
- Predictable interface per endpoint
