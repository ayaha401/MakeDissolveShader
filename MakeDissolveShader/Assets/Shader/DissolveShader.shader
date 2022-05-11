Shader "Unlit/DissolveShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DissolveTex("Dissolve Texture",2D) = "white"{}
        _DissolveAmount("Dissolve Amount",Range(0.0, 1.0)) = 0.0
    }
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 dissolveUV : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 dissolveUV : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex; float4 _MainTex_ST;

            sampler2D _DissolveTex; float4 _DissolveTex_ST;

            float _DissolveAmount;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.dissolveUV = TRANSFORM_TEX(v.uv, _DissolveTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float dissolve = tex2D(_DissolveTex,i.dissolveUV).r * 0.9999;
                float isVisible = dissolve - _DissolveAmount;
                clip(isVisible);

                col.rgb *= col.a;
                return col;
            }
            ENDCG
        }
    }
}
