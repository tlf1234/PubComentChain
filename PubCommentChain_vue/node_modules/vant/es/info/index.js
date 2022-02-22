import _mergeJSXProps from "@vue/babel-helper-vue-jsx-merge-props";
import { createNamespace, isDef } from '../utils';
import { inherit } from '../utils/functional'; // Types

var _createNamespace = createNamespace('info'),
    createComponent = _createNamespace[0],
    bem = _createNamespace[1];

function Info(h, props, slots, ctx) {
  if (!isDef(props.info) || props.info === '') {
    return;
  }

  return h("div", _mergeJSXProps([{
    "class": bem()
  }, inherit(ctx, true)]), [props.info]);
}

Info.props = {
  info: [Number, String]
};
export default createComponent(Info);