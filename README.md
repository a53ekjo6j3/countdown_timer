# countdown_timer

## Usage

```dart
class _MyHomePageState extends State<MyHomePage> {
  final CountdownTimerController controller = CountdownTimerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CountdownTimer(
              controller: controller,
              builder: (context, ctt) {
                return Text(
                  ctt.toString(),
                  style: const TextStyle(fontSize: 36),
                );
              },
            ),
            Container(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => controller.startTimer(
                    duration: const Duration(minutes: 5),
                  ),
                  child: const Text('START'),
                ),
                TextButton(
                  onPressed: controller.pause,
                  child: const Text('PAUSE'),
                ),
                TextButton(
                  onPressed: controller.resume,
                  child: const Text('RESUME'),
                ),
                TextButton(
                  onPressed: controller.cancel,
                  child: const Text('CANCEL'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
```
