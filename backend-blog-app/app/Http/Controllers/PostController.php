<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PostController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response([
            'data'=>Post::latest()->with('user:id,name,image')->withCount('comments','likes')->get(),
            'msg'=>"Success"
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validate= Validator::make($request->all(),[
            "body"=>'required'
        ]);

        if($validate->fails()){
            return response()->json($validate->errors(), 422);
        }

        $data = Post::create([
            "body"=>$request->body,
            "user_id"=>auth()->user()->id
        ]);

        return response([
            'msg'=>"Success Created Post",
            'data'=>$data
        ],200);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        return response([
            'data'=>Post::withCount("comments","likes")->find($id)
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Post $post)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request,$id)
    {
        $validate= Validator::make($request->all(),[
            "body"=>'required'
        ]);

        if($validate->fails()){
            return response()->json($validate->errors(), 422);
        }

        $data = Post::find($id)->update([
            "body"=>$request->body
        ]);

        return response([
            'msg'=>"Success Created Post",
            'data'=>$data
        ],200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $post = Post::find($id);
        if(!$post){
            return response([
                "msg"=>" post not found "
            ],401);
        }

        if($post->user_id != auth()->user()->id){
            return response([
                "msg"=>" Permission Denied "
            ],401);
        }

        $post->cooments()->delete();
        $post->likes()->delete();
        $post->delete();
        return response([
            "msg"=>" Delete Success "
        ],200);
    }
}
