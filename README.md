# App 06 | 레시피 목록과 상세

모바일프로그래밍 **7주차** 학생용 Flutter 실습 프로젝트입니다. 여섯 번째 앱(Lab 06)이며, JSON 데이터를 `Recipe` 모델로 변환하여 목록과 상세 화면에 표시합니다.

**Android 플랫폼이 저장소에 포함되어 있어 별도의 플랫폼 생성 명령 없이 시작할 수 있습니다.** OpenAI API 키는 필요하지 않습니다.

## 1. Android Studio에서 시작하기

1. **File → New → Project from Version Control**에서 `https://github.com/suseol/app06_recipe_guide.git`을 clone합니다.
2. clone한 `app06_recipe_guide` 폴더를 Flutter 프로젝트로 엽니다.
3. **Tools → Flutter → Flutter Pub Get**을 실행합니다. Flutter SDK와 Android SDK가 설정되어 있어야 합니다.
4. Android 실기기나 에뮬레이터를 선택합니다.
5. 기본 실행 대상 `lib/main.dart`로 **Run**합니다.

처음에는 '레시피 앱을 시작합니다.'라는 문구만 보입니다. 서버 조회와 목록 UI는 수업에서 순서대로 구현합니다.

터미널을 사용한다면 `flutter pub get` 후 `flutter run`을 실행할 수도 있습니다.

## 2. 실습 단계

| 단계 | 학습 내용 |
|---|---|
| S00 | 제공 starter 실행 |
| S01 | HTTP GET, 응답 코드, JSON Map |
| S02 | `Recipe.fromJson()`과 모델 객체 |
| S03 | `Image.network()`로 레시피 이미지 표시 |
| S04 | `recipes` 배열을 `List<Recipe>`로 변환 |
| S05 | 목록에서 상세로 `Recipe` 객체 전달 |
| S06 | `Navigator.pop(result)`로 선택 결과 반환 |
| S07 | 로딩 상태 표현 |
| S08 | 오류, 재시도, 빈 목록 |
| S09 | 이미지 오류를 데이터 조회 오류와 구분 |

교수자가 제공하는 **Lab06 실습 진행서**에 따라 `lib/main.dart`를 직접 작성합니다. 화면 구성에 익숙한 UI 코드는 제공하고 HTTP, JSON, 모델 변환 등 새로운 요소는 수업에서 함께 작성합니다.

## 3. Checkpoint: 오류 복구용

진도 차이로 코드를 다시 맞춰야 할 때만 사용합니다. 파일 하나를 `lib/main.dart`로 **복사해 덮어쓰기**한 뒤 앱을 다시 실행합니다. 작업 중인 자신의 코드는 먼저 따로 보관하세요.

| 파일 | 복구 지점 |
|---|---|
| `checkpoints/main_cp01_single_recipe.dart` | S03: 단일 레시피와 이미지 |
| `checkpoints/main_cp02_detail_result.dart` | S06: 목록, 상세, 선택 결과 반환 |
| `checkpoints/main_cp03_error_retry.dart` | S09: 로딩, 오류와 재시도를 포함한 완성 흐름 |

이 파일들은 **수업 도중 다시 합류하기 위한 복구본**입니다. 학생이 처음부터 복사해 사용하는 것이 아니라 현재 단계까지 직접 작성한 뒤 필요한 경우 활용합니다. 체크포인트는 모두 독립 실행이 가능하지만 기본 실행 파일은 `lib/main.dart`입니다.

## 4. 알아둘 사항

- 레시피 데이터와 사진은 [DummyJSON Recipes](https://dummyjson.com/docs/recipes)에서 네트워크로 가져옵니다.
- Android 인터넷 권한은 `android/app/src/main/AndroidManifest.xml`에 포함되어 있습니다.
- 위젯의 상태 변경 후에도 초기화 코드를 다시 실행해야 하는 경우에는 **Hot Restart**를 사용합니다.
- `android/`는 Flutter Android 플랫폼 프로젝트이며, `build/`, `.dart_tool/`, `android/local.properties`는 로컬에서 생성됩니다.
- 교수자용 `solution/`, `teacher/`, `steps/` 전체 소스는 학생용 저장소에 제공하지 않습니다.

이 저장소의 프로젝트 이름은 `app06_recipe_guide`로 통일합니다.
