<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CommentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($id)
    {
        $data = Post::find($id);

        if(!$data){
            return response([
                "msg"=>"Post Not found"
            ],401);
        }

        return response([
            "data"=>$data->comments()->with("user:id,name,image")->get()
        ],200);
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
    public function store(Request $request,$id)
    {
        $data = Post::find($id);

        if(!$data){
            return response([
                "msg"=>"Post Not found"
            ],401);
        }

        $validate= Validator::make($request->all(),[
            "comment"=>'required'
        ]);

        if($validate->fails()){
            return response()->json($validate->errors(), 422);
        }

        $datas = Comment::create([
            'body'=>$request->comment,
            'post_id'=>$id,
            'user_id'=>auth()->user()->id
        ]);

        return response([
            "data"=>$datas,
            "msg"=>"comment created"
        ],200);
    }

    public function update(Request $request, $id)
    {
        $comment = Comment::find($id);

        if(!$comment){
            return response([
                "msg"=>"Comment Not Found"
            ],401);
        }

        if($comment->user_id != auth()->user()->id){
            return response([
                "msg"=>" Permission Denied "
            ],401);
        }

        $validate= Validator::make($request->all(),[
            "comment"=>'required'
        ]);

        if($validate->fails()){
            return response()->json($validate->errors(), 422);
        }

        $comment->update([
            "body"=>$request->comment
        ]);

        return response([
            "msg"=>"update success"
        ],200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $comment = Comment::find($id);

        if(!$comment){
            return response([
                "msg"=>"Comment Not Found"
            ],401);
        }

        if($comment->user_id != auth()->user()->id){
            return response([
                "msg"=>" Permission Denied "
            ],401);
        }

        $comment->delete();

        return response([
            "msg"=>"Comment Deleted"
        ],200);
    }
}
