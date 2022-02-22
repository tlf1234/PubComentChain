<template>
  <div>
    <!-- img src="../../public/img -->
    <!-- {{active}} -->
    <!-- <div class="logo"> -->
    <img src="../../public/img/logo.jpg" class="logo" />
    <!-- </div> -->
    <div class="lang" v-if="defaultLang == 'cn'" @click="changeLang('en')">
      English
    </div>
    <div class="lang" v-else @click="changeLang('cn')">中文</div>
    <!-- 触发钱包连接 -->
    <div class="linkWallet" @click="changeLang('cn')">连接钱包</div>

    <div class="operate_activity">
      <div class="create_activity" @click="changeLang('cn')">创建评定</div>
      <div class="partin_activity" @click="changeLang('cn')">参与评定</div>
    </div>

    <div class="search">
      <myHeaderSearch></myHeaderSearch>
    </div>

    <!-- 注意这个控件的model参数，这个问题导致了问题，进行了定位-->
    <mt-tab-container v-model="active">
      <transition name="tab-item">
        <mt-tab-container-item id="evaHead" key="evaHead">
          <div class="cityAndShow cf">
            <div class="changeh">
              <h2 @click="evalue_home" class="h2" id="home">首页</h2>
              <h2 @click="evalue_film" class="h2" id="film">电影</h2>
              <h2 @click="evalue_watchTV" class="h2" id="watchTV">电视剧</h2>
              <h2 @click="evaluate_rank" class="h2" id="evarank">评定榜</h2>
            </div>
          </div>
          <!-- 轮播控件 -->
          <!-- <van-swipe :autoplay="3000">
            <van-swipe-item
              v-for="(item, i) of list"
              :key="i"
              class="carouselImg"
            >
              <img :src="`http://127.0.0.1:5050/${item.img_url}`" alt="" />
            </van-swipe-item> </van-swipe
          >  -->
          <div class="ItemList">
            <mt-tab-container v-model="activeTwo">
              <mt-tab-container-item id="home">
                <!-- 这里是正在热映的内容 -->
                <movie-list :is_show="1"></movie-list>
              </mt-tab-container-item>

              <mt-tab-container-item id="film" v-show="activeTwo == 'home'">
                <!-- 这里是即将上映的内容 -->
                <!-- <movie-list :is_show="0"></movie-list> -->
              </mt-tab-container-item>

              <mt-tab-container-item
                id="watchTV"
                v-show="activeTwo == 'watchTV'"
              >
                <!-- 这里是即将上映的内容 -->
                <watchTVList :is_show="0"></watchTVList>
              </mt-tab-container-item>

              <mt-tab-container-item
                id="evarank"
                v-show="activeTwo == 'watchTV'"
              >
                <!-- 这里是即将上映的内容 -->
                <!-- <movie-list :is_show="0"></movie-list> -->
              </mt-tab-container-item>
            </mt-tab-container>
          </div>
        </mt-tab-container-item>
      </transition>
    </mt-tab-container>
  </div>
</template>
<script>
//导入一个axios.js
import obj from "../assets/api/axios.js";
//对导入的对象解构
var { movieCarousel, hello } = obj;
import myHome from "./my/MyHome.vue";
import movieList from "./movie/MovieList";
import watchTVList from "./watchTV/WatchTVList";
//1.2引入底部导航条的图片切换组件
// import TabarIcon from "./movie/TabarIcon.vue";
import myHeaderSearch from "../components/HeaderSearch";

export default {
  data() {
    return {
      //active保存的是一个字符串：子面板id
      active: "evaHead",

      list: [],
      time: 0,
      oldActivity: "home",
      activeTwo: "home",
      carouselimg: "http:127.0.0.1:5050",
    };
  },

  // 启动函数
  mounted() {
    //注意下面的逻辑是：getActiveTwo为上面的控件中的Id,根据这个Id就能获得这个控件，并且可以根据Id获得Item,然后对这个控件设置背景。
    var act = this.getActiveTwo;
    var doc = document.getElementById(act);
    doc.style.borderBottom = "2px solid #ff2e62";

    this.init(); //初始化函数，web3相关也可以放到这里
  },
  methods: {
    init: async function () {
      // this.initLang();
      // this.initSuperiorID();
      return this.initWeb3();
    },

    initWeb3: async function () {
      if (window.ethereum) {
        window.web3 = new window.Web3(window.ethereum);
        try {
          await window.ethereum.enable();
          this.web3Provider = window.ethereum;
        } catch (error) {}
      } else if (window.web3) {
        this.web3Provider = window.web3.currentProvider;
        window.web3 = new window.Web3(window.web3.currentProvider);
      } else {
        console.log(
          "Non-Ethereum browser detected. You should consider trying MetaMask!"
        );
        window.web3 = new window.Web3(
          new window.Web3.providers.HttpProvider("https://mainnet-eth.token.im")
        );
        this.web3Provider = window.web3.currentProvider;
        this.authed = false;
      }
      if (this.authed) this.checkAccount();

      // return this.initGame();
    },

    checkAccount: function () {
      let _this = this;
      _this.account = window.web3.eth.coinbase;
      setInterval(() => {
        if (_this.account !== window.web3.eth.coinbase) {
          _this.account = window.web3.eth.coinbase;
          window.location.reload();
        }
      }, 3000);
    },

    //防止页面后退
    // https://www.cnblogs.com/sunshq/p/7976827.html
    fobidden_back() {
      //防止页面后退
      window.addEventListener("popstate", function () {
        // history.pushState(null, null, document.URL);
        history.pushState(null, null, location.href);
      });
    },

    //轮播图
    onload() {
      var url = "movie/v1/carousel";
      this.axios.get(url).then((res) => {
        if (res.data.code == 1) {
          this.list = res.data.data;
        }
      });
    },

    //切换（正在热映）-（即将上映） 在这里保存住activeTwo的信息，在城市选择页面跳转过来时，可以回到原位置
    evalue_home(e) {
      var doc = document.getElementById(this.oldActivity);
      doc.style.borderBottom = "none";

      this.activeTwo = "home";
      e.target.style.borderBottom = "2px solid #ff2e62";

      this.oldActivity = "home";

      //为了减少代码，可以用一个记录来实现下述激活功能。
      // var doc = document.getElementById("film");
      // doc.style.borderBottom = "none";

      // var doc = document.getElementById("watchTV");
      // doc.style.borderBottom = "none";

      // var doc = document.getElementById("evarank");
      // doc.style.borderBottom = "none";

      this.$store.commit("changeActiveTwo", this.activeTwo);
    },

    evalue_film(e) {
      var doc = document.getElementById(this.oldActivity);
      doc.style.borderBottom = "none";

      this.activeTwo = "film";
      e.target.style.borderBottom = "2px solid #ff2e62";

      this.oldActivity = "film";
      // var doc = document.getElementById("home");
      // doc.style.borderBottom = "none";

      // var doc = document.getElementById("watchTV");
      // doc.style.borderBottom = "none";

      // var doc = document.getElementById("evarank");
      // doc.style.borderBottom = "none";

      this.$store.commit("changeActiveTwo", this.activeTwo);
    },

    evalue_watchTV(e) {
      var doc = document.getElementById(this.oldActivity);
      doc.style.borderBottom = "none";

      this.activeTwo = "watchTV";
      e.target.style.borderBottom = "2px solid #ff2e62";

      this.oldActivity = "watchTV";
      // var doc = document.getElementById("home");
      // doc.style.borderBottom = "none";

      // var doc = document.getElementById("film");
      // doc.style.borderBottom = "none";

      // var doc = document.getElementById("evarank");
      // doc.style.borderBottom = "none";

      this.$store.commit("changeActiveTwo", this.activeTwo);
    },

    evaluate_rank(e) {
      var doc = document.getElementById(this.oldActivity);
      doc.style.borderBottom = "none";

      this.activeTwo = "evarank";
      e.target.style.borderBottom = "2px solid #ff2e62";

      this.oldActivity = "evarank";
      // var sib = e.target.previousElementSibling;
      // sib.style.borderBottom = "none";

      // var doc = document.getElementById("home");
      // doc.style.borderBottom = "none";

      // var doc = document.getElementById("film");
      // doc.style.borderBottom = "none";

      // var doc = document.getElementById("watchTV");
      // doc.style.borderBottom = "none";

      this.$store.commit("changeActiveTwo", this.activeTwo);
    },
  },
  created() {
    this.fobidden_back(),
      //使用promise 导入外部的js代码，异步向服务器发起请求；
      movieCarousel()
        .then((res) => {
          this.list = res;
          console.log("在home.vue中import这个axios，并且使用promise来调用它");
          console.log(res);
        })
        .catch((e) => {
          console.log(e);
        });
    //组件刷新，获取vuex里的active；
    this.active = this.getActive;
    this.activeTwo = this.getActiveTwo;
  },
  computed: {
    //计算属性，获取vuex里的active；
    getActive() {
      return this.$store.state.active;
    },
    //计算属性，获取vuex里的activeTwo；
    getActiveTwo() {
      return this.$store.state.activeTwo;
    },
  },
  components: {
    //注册子组件
    movieList,
    // tabaricon: TabarIcon,
    watchTVList,
    myHome,
    myHeaderSearch,
  },
};
</script>	
<style scoped>
.tab-item-enter-active,
.tab-item-leave-active {
  will-change: transform;
  transition: all 0.3s;
  position: absolute;
  width: 100%;
  left: 0;
}
.tab-item-enter {
  transform: translateX(-100%);
}
.tab-item-leave-active {
  transform: translateX(100%);
}

.logo {
  /* float: left; */
  margin: 20px auto 20px 40px;
  /* top: 20px;
  left: 20px; */
  height: 60px;
}
.lang {
  float: right;
  margin: 30px 40px 20px auto;
  background-color: #eef;
}
.operate_activity {
  display: flex;
  /* background-color: rgb(214, 150, 211); */
}
.create_activity {
  /* float: left; */
  top: 10px;
  margin-left: 250px;
  width: 200px;
  height: 50px;
  padding: 10px 0;
  text-align: center;
  border-radius: 15px;
  font-size: 20px;
  color: #fff;
  background-color: rgb(214, 150, 211);
}
.partin_activity {
  margin-left: 200px;
  width: 200px;
  height: 50px;
  padding: 10px 0;
  text-align: center;
  border-radius: 15px;
  font-size: 20px;
  color: #fff;
  background-color: rgb(214, 150, 211);
}
.linkWallet {
  float: right;
  margin: 60px 10px;
  width: 80px;
  height: 30px;
  font-size: 15px;
  border-radius: 5px;
  /* 调节垂直间距 */
  padding: 4px 0;
  text-align: center;

  background-color: rgb(150, 214, 177);
}
.search {
  float: right;
  /* margin: 20px auto 20px 40px;
  height: 50px; */
  margin: 20px 50px;
  width: 30%;
  height: 30px;
  border-radius: 50px;
}

.cityAndShow {
  float: left;
  margin: 20px 50px;
  /* margin-left: 0px;
  margin-top: 150px; */
  /* display: flex; */
  /* justify-content: space-between; */
  /* padding: 1rem 2rem; */
}
.changeh {
  width: 360px;
  z-index: 20;
  margin-left: 10px;
  background-color: rgba(229, 226, 226, 0.808);
  height: 50px;
  line-height: 50px;
  display: flex;
  border-radius: 5px;
}
.h2 {
  font-size: 18px;
  padding: 2px 10px;
  margin: 0px 6px;
  cursor: pointer;
  /* border-bottom:2px solid #ff2e62; */
}
.ItemList {
  float: left;
  width: 100%;
  height: 100%;
}

.carouselImg img {
  width: 100%;
}

.mint-tabbar > .mint-tab-item {
  color: #2c2c2c;
}
/* 4.修改组件默选中样式 */
.mint-tabbar > .mint-tab-item.is-selected {
  background-color: transparent;
  color: #ff4d64;
}
</style>
