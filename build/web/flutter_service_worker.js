'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "dbfa6fec95b125d5297c7a5cccc717c2",
"assets/AssetManifest.bin.json": "122dbcafce186071322249c0f754751e",
"assets/AssetManifest.json": "5832a9ffa7599d21cdc83f9b3563a577",
"assets/assets/fonts/Silka-Black.otf": "886322ed64ddb05da4ded5885d80da75",
"assets/assets/fonts/Silka-BlackItalic.otf": "76fd98a2ca01e330c83fd25469363a45",
"assets/assets/fonts/Silka-Bold.otf": "12525b4c746ed034e64894c5d0565a04",
"assets/assets/fonts/Silka-BoldItalic.otf": "571a2f918df658db6bf03ca48c8dd2a8",
"assets/assets/fonts/Silka-ExtraLight.otf": "9841afef7b75b73f38dde4f3f74ca8bc",
"assets/assets/fonts/Silka-ExtraLightItalic.otf": "4af7e7da589810e5e2ec9c338b32076f",
"assets/assets/fonts/Silka-Light.otf": "9bdcb58d062c64795ccc872b4a2617a7",
"assets/assets/fonts/Silka-LightItalic.otf": "df5fbc5498ab30398f3c677aa88cab98",
"assets/assets/fonts/Silka-Medium.otf": "88675fb35da9334ff160902d1c5af756",
"assets/assets/fonts/Silka-MediumItalic.otf": "4f0d62620d9607e625297bf06ec3b2e7",
"assets/assets/fonts/Silka-Regular.otf": "c7b6f4d143875ead3ba4a4a36b24dec6",
"assets/assets/fonts/Silka-RegularItalic.otf": "a66eb53ad86dc08c1ee1cc8aab34305e",
"assets/assets/fonts/Silka-SemiBold.otf": "dff78ad7a52f755df530384e5634b954",
"assets/assets/fonts/Silka-SemiBoldItalic.otf": "953dd86dfef7bed4094f6c327553397a",
"assets/assets/fonts/Silka-Thin.otf": "4cccc93d2e3e39cb6c61af733de29517",
"assets/assets/fonts/Silka-ThinItalic.otf": "ce3206f0b9c52b1fad4e1ae75de7f2ab",
"assets/assets/images/emmi-nail-Logo-4C-rot.png": "ecd3ff0bc7ebbfae47f301ecc442c651",
"assets/assets/images/emmi-nail-Logo-4C-schwarz.png": "149884ed96ab7bcae8a6680b027185c9",
"assets/assets/images/emmi-nail-Logo-4C-weiss.png": "0a862ae13addbf4c2f4f06bb48c3f21c",
"assets/assets/images/nail_art.jpg": "dff015700f85f11ebe1c80b376236849",
"assets/assets/images/promo1.jpg": "b6d2704399c3fcaef03cc594dabc80dc",
"assets/FontManifest.json": "4f7c7a881da06e4fa7211592b41a6f9b",
"assets/fonts/MaterialIcons-Regular.otf": "8e0180480b532a14e84df294ecc8752d",
"assets/NOTICES": "c08294bafd844e5b9a5878e1bb0ea5f9",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "3c32c3435da9d090c3ea231d2d6f0575",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "121b54b30db12c138aa25feb1ae9410e",
"/": "121b54b30db12c138aa25feb1ae9410e",
"main.dart.js": "48697aa0a2936e10a3c901cedd183dfe",
"manifest.json": "0cca25dea4c265eb3506de60b7726508",
"version.json": "f330aed5a65e20147e3df669e35631f8"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
