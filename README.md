<div align="center"><h2> swift-animations</h2></div>

<div align="center"><img src="https://raw.githubusercontent.com/hello-woody/img-uploader/master/uPic/swift%20animation.png"></div>

### Introduce

👋🏻 Hi, I'm 이재용, wanna be good iOS developer.

Inspired by Chanhee Jung, Younghoo Im (my academy collegues) and also dribbles, I created animations in Swift.
Animations are something that I really like, so I will add animations continually to this repository. I hope that anyone who comes to this repository will be inspired by animations, then create other wonderful animations.

찬희, 영후 (아카데미 동료들)에게, 그리고 드리블에서 영감 받아 Swift로 몇 가지 애니메이션을 공부하며 만들었습니다. 애니메이션을 직접 만드는 것은 정말 재밌고 신나는 경험이었습니다! 앞으로도 계속해서 추가하려고 해요. 누구든 아래 예제들을 보고 영감 받아 더 멋진 애니메이션을 구현하셨으면 좋겠습니다! 

<br />

<br />

### Animations

1. 이미지 frame을 이용한 화면 전환 애니메이션 - unsplashed clone app

`UIViewControllerTransitioningDelegate` / `UIPresentationController` / `UIViewControllerAnimatedTransitioning` 

<img src="Animation 1 - Unsplash/unsplash.gif" width="250"> 

2. 동그라미 로딩 애니메이션 - circular loading animation

- `CABasicAnimation` / `CAKeyframeAnimation` / `CAReplicatorLayer``
- ``CoreAnimation`을 학습하며 애플 문서의 기본 예제들로부터 영감을 받아 만들었습니다. 

<img src="Animation 2 - Circular Loading/Circular Loading Animation.gif" width="250"> 

3. 별 배경 애니메이션 - shining star background animation 

- `CAGradientLayer` / `CABasicAnimation` / `CAKeyframeAnimation` / `drand48()` / `Double.random(in: 0...1)` / `CATransaction` / `UIBezierPath` 
- 우주 컨셉 프로젝트를 진행하다 밋밋한 앱 배경을 CoreAnimation을 통해 활력을 주었습니다. 실제 앱의 배경에 전체적으로 넣었습니다. (앱 스토어에 올라오면 공유할게요!)

<img src="Animation 3 - Star Background/shining star background animation.gif " width="250"> 

4. 만나지 않는 3개의 호 애니메이션 - three circular loading animation

- `UIBezierPath` / `CABasicAnimation` / `AnchorPoint` vs `Position` / Math
- [유튜브](https://www.youtube.com/watch?v=1Aq9OJuS3ok)의 알고리즘이 추천해준 영상을 보고 영감을 받아 만들었습니다. 원의 각도를 계산하기 위해 `asin`을 사용했습니다. 
  수학적인 생각과 연산을 통해 구현할 수 있는 재밌는 애니메이션입니다. 

<img src="Animation 4 - Three Circular Loading/three circular loading.gif" width="250"> 

5. 우주비행사 리프레시 애니메이션 - astronaut refresh animation 

- `UIScrollViewDelegate` / `UIView.animate` / `CABasicAnimation` / `CAKeyframeAnimation` / `UIBezierPath`
- 스크롤 정도에 따라 우주비행사가 이동하며 로딩되는 동안 우주비행사가 돌고 로딩이 완료되면 다시 원상복귀되는 애니메이션입니다. 

<img src="Animation 5 - Blackhole Refresh/astronaut refresh animation.gif" width="250"> 

<br />

<br />

### Reference

**Design Concepts**

- Swift Documentation
- [Dribble](https://dribbble.com)
- My Collegues ([chaneeii](https://github.com/chaneeii), [Asher3576](https://github.com/Asher3576))
- [cubic-bezier](https://cubic-bezier.com/#.1,.97,.82,.07)

**Developments**

- Swift Documentation
- [Core Animation Basics Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/CoreAnimationBasics/CoreAnimationBasics.html#//apple_ref/doc/uid/TP40004514-CH2-SW3)
- [Raywenderlich](https://www.kodeco.com/books/ios-animations-by-tutorials/v6.0/chapters/14-layer-keyframe-animations-struct-properties)

