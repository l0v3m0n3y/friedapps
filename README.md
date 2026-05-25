# friedapps
api for friedapps.com temp email service. Generate temporary email addresses with one click and receive emails directly in your browser toolbar. No sign-up required.
# main
```swift
import Foundation
import friedapps
let client = Friedapps()

do {
    let email_info = try await client.generate_email()
    print(email_info)
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swift run
```
