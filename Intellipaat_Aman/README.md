1. Architecture

The app uses MVVM. Each screen has a SwiftUI view and a view model: login, course dashboard, and course details. The view draws ScreenState (loading, success, empty, or failure). The view model calls a service. AuthService and CourseService both go through one APIClient, which takes the URL and GET or POST.

MVVM keeps the screens small and the rules testable. The unit test marks a lesson complete and checks that progress changes from 65% to 70% without opening the UI.

2. Offline support

After a successful course fetch, CourseCache writes the list to courses-cache.json in the app caches directory. The next fetchCourses() tries the network first. If that call fails, it decodes the same file and returns those courses. Lesson names are created on the device from the course’s lesson count, so the details screen does not need another request. If the app has never loaded courses, there is no file and the dashboard shows the failure state.

3. Security

In production, store the access token and refresh token in the Keychain. Send the access token only in the Authorization: Bearer header. Keep it out of UserDefaults, plain files, and logs. This demo does not save the DummyJSON token.

4. Scale

With 1 million users and hundreds of courses:

Page the course API and search on the server instead of downloading one JSON file.
Store each user’s lesson progress on the server and sync it, instead of keeping it only on the device.
Replace the single cache file with a local database so lists and updates are not a full rewrite of every course.
Serve lesson content and images from a CDN and cache them by course id.
Add refresh-token renewal, pagination, and request limits so one client cannot pull the whole catalog.
5. Android

Use the same MVVM split. Jetpack Compose would host the three screens, and a ViewModel plus StateFlow would hold the same loading, success, empty, and failure states. Retrofit or Ktor would replace APIClient. A repository would fetch courses, write the last response to a cache file or Room, and read that cache when the device is offline. Navigation Compose would go from login to the dashboard to course details. Tokens would go in the Android Keystore or EncryptedSharedPreferences, which is the same role as the iOS Keychain.